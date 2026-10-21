/*
    SCMicroSynth - Module: Engine
    Define los SynthDefs del sintetizador (\fm, \sync, \masterLimiter),
    gestiona buses de audio privados y grupos de ejecución.
*/

var engineModule = (
    server: nil,
    audioBus: nil,
    synthGroup: nil,
    fxGroup: nil,
    masterSynth: nil,

    init: { |self, srv|
        self.server = srv ? Server.default;
        self.defineSynthDefs;
        self.setupAudioGraph;
        self;
    },

    defineSynthDefs: { |self|
        // 1. Motor FM de 2 moduladores en cascada
        SynthDef(\fmVoice, {
            arg out = 0, amp = 1.0, gate = 1,
            f = 220, det = 1,

            // Ratios de frecuencia (Carrier, Mod1, Mod2)
            c = 1, m1 = 1, i_m2 = 1,

            // Índices de modulación
            i1 = 0,   // Mod1 -> Carrier
            i_i2 = 0, // Mod2 -> Mod1

            // Vibrato
            fVib = 5, aVib = 0, tVib = 0,

            // Envolvente Mod2 (ADSR)
            i_m2At = 0, i_m2De = 0, i_m2Su = 1, i_m2Re = 0, i_m2Curv = 0, i_m2Offset = 0,

            // Envolvente Mod1 (ADSR)
            m1At = 0, m1De = 0, m1Su = 1, m1Re = 0, m1Curv = 0, m1Offset = 0,

            // Envolvente Carrier (DADSR)
            cDt = 0, cAt = 0.01, cDe = 0.3, cSu = 0.5, cRe = 1.0, cCurv = -2;

            var safeC, m2Env, m1Env, cEnv, vib, cFrec, m1Ratio, m2Ratio, m1Amp, m2Amp, m1Frec, m2Sig, sig;

            // Salvaguarda matemática contra división por cero
            safeC = c.abs.max(0.001);

            // Envolventes
            m2Env = EnvGen.kr(
                Env.adsr(i_m2At, i_m2De, i_m2Su, i_m2Re, curve: i_m2Curv, bias: i_m2Offset),
                gate
            );

            m1Env = EnvGen.kr(
                Env.adsr(m1At, m1De, m1Su, m1Re, 1.0, curve: m1Curv, bias: m1Offset),
                gate
            );

            cEnv = EnvGen.kr(
                Env.dadsr(cDt, cAt, cDe, cSu, cRe, curve: cCurv),
                gate,
                doneAction: 2 // Libera el nodo automáticamente en el servidor
            );

            // Vibrato
            vib = LFTri.kr(fVib, mul: Line.kr(0, aVib, tVib.max(0.001)));
            cFrec = (f + (vib * det)).max(10.0);

            // Ratios
            m1Ratio = m1 / safeC;
            m2Ratio = i_m2 / safeC;

            // Amplitudes de modulación
            m1Amp = f * i1;
            m2Amp = (cFrec * m1Ratio) * i_i2;

            // Síntesis FM en cascada: Mod2 -> Mod1 -> Carrier
            m1Frec = cFrec * m1Ratio;
            m2Sig = SinOsc.ar(m1Frec * m2Ratio) * m2Amp * m2Env;

            sig = SinOsc.ar(
                cFrec + (
                    SinOsc.ar(m1Frec + m2Sig) * m1Amp * m1Env
                )
            ) * cEnv;

            // Salida con control de amplitud (se envía al bus de efectos/master)
            Out.ar(out, (sig * amp) ! 2);
        }).add;

        // 2. Motor Hard-Sync
        SynthDef(\syncVoice, {
            arg out = 0, amp = 1.0, gate = 1,
            f = 220, det = 1,
            c = 1, slaveRatio = 2, sweepAmt = 1000,
            fVib = 5, aVib = 0, tVib = 0,
            swAt = 0.01, swDe = 0.5, swSu = 0, swRe = 1, swCurv = -4,
            cDt = 0, cAt = 0.01, cDe = 0.3, cSu = 0.5, cRe = 1, cCurv = -2;

            var sweepEnv, cEnv, vib, masterFreq, slaveFreq, sig;

            sweepEnv = EnvGen.kr(Env.adsr(swAt, swDe, swSu, swRe, curve: swCurv), gate);
            cEnv = EnvGen.kr(Env.dadsr(cDt, cAt, cDe, cSu, cRe, curve: cCurv), gate, doneAction: 2);

            vib = LFTri.kr(fVib, mul: Line.kr(0, aVib, tVib.max(0.001)));
            masterFreq = ((f + (vib * det)) * c).max(10.0);
            slaveFreq = (masterFreq * slaveRatio) + (sweepEnv * sweepAmt);

            sig = SyncSaw.ar(masterFreq, slaveFreq.max(10.0)) * cEnv;

            Out.ar(out, (sig * amp) ! 2);
        }).add;

        // 3. Master Limiter & Output Stage (Previene clipping analógico/digital)
        SynthDef(\masterStage, {
            arg inBus = 0, outBus = 0, masterVol = 0.2;
            var inSig, limitedSig;

            inSig = In.ar(inBus, 2);
            limitedSig = Limiter.ar(inSig * masterVol, level: 0.95, dur: 0.01);
            ReplaceOut.ar(outBus, limitedSig);
        }).add;
    },

    setupAudioGraph: { |self|
        if(self.server.serverRunning) {
            self.audioBus = Bus.audio(self.server, 2);
            self.synthGroup = Group.new(self.server, \addToHead);
            self.fxGroup = Group.after(self.synthGroup);

            self.masterSynth = Synth.tail(self.fxGroup, \masterStage, [
                \inBus, self.audioBus,
                \outBus, 0,
                \masterVol, 0.2
            ]);
        };
    },

    setMasterVolume: { |self, vol|
        if(self.masterSynth.notNil) {
            self.masterSynth.set(\masterVol, vol.clip(0.0, 1.0));
        };
    },

    cleanup: { |self|
        self.masterSynth.free;
        self.synthGroup.free;
        self.fxGroup.free;
        self.audioBus.free;
    }
);

engineModule;
