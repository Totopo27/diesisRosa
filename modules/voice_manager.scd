/*
    SCMicroSynth - Module: Voice Manager
    Controla la polifonía de forma segura:
    - Previene fugas de nodos (Voice leaks).
    - Asocia notas MIDI/OSC a nodos Synth activos.
    - Maneja pánico suave (All Notes Off) y duro (All Sound Off).
*/

var voiceManagerModule = (
    engine: nil,
    tuning: nil,
    presets: nil,

    // Diccionario de voces activas mapeadas por canal y número de nota: "ch_nn" -> Synth
    activeVoices: IdentityDictionary.new,

    currentScaleKey: \tet31,
    currentScaleData: nil,
    currentPresetKey: \fmBell,

    octaveShift: 0, // En saltos de octava (factor 2 ** octaveShift)
    masterVolume: 0.2,

    init: { |self, engineMod, tuningMod, presetsMod|
        self.engine = engineMod;
        self.tuning = tuningMod;
        self.presets = presetsMod;

        self.currentScaleData = self.tuning.getScale(self.currentScaleKey);
        self;
    },

    setScale: { |self, scaleKey|
        self.currentScaleKey = scaleKey.asSymbol;
        self.currentScaleData = self.tuning.getScale(self.currentScaleKey);
        ("Escala activa cambiada a: " ++ self.currentScaleKey).postln;
    },

    setPreset: { |self, presetKey|
        self.currentPresetKey = presetKey.asSymbol;
        ("Preset activo cambiado a: " ++ self.currentPresetKey).postln;
    },

    setOctaveShift: { |self, oct|
        self.octaveShift = oct.asInteger;
        ("Transposición de octava: " ++ self.octaveShift).postln;
    },

    // Disparo de nota polifónica segura (Voice Safe)
    noteOn: { |self, noteNumber, velocity = 100, channel = 0|
        var voiceKey = (channel.asString ++ "_" ++ noteNumber.asString).asSymbol;
        var fBase, fCarrier, presetDict, presetArgs, synthArgs, multOctave;
        var cRatio, m1Ratio;

        // 1. Evitar Voice Leaks: si ya había una voz sonando en esta misma tecla/canal, cerrarla limpiamente
        if(self.activeVoices[voiceKey].notNil) {
            self.activeVoices[voiceKey].set(\gate, 0);
            self.activeVoices[voiceKey] = nil;
        };

        // 2. Cálculo de frecuencia fundamental microtonal
        if(noteNumber < self.currentScaleData.size) {
            fBase = self.currentScaleData.at(noteNumber);
        } {
            fBase = 440.0;
        };

        multOctave = 2.pow(self.octaveShift);
        fBase = (fBase * multOctave).clip(15.0, 18000.0);

        // 3. Obtener el preset actual y calcular la frecuencia de portadora según Forma Normal de Truax
        presetDict = self.presets.getPreset(self.currentPresetKey);
        cRatio = (presetDict[\c] ? 1).asFloat;
        m1Ratio = (presetDict[\m1] ? 1).asFloat;

        // Si C:M no está en Forma Normal, compensamos fCarrier para que la fundamental escuchada sea fBase
        fCarrier = self.engine.calcCarrierFreq(fBase, cRatio, m1Ratio);

        presetArgs = self.presets.asArgsArray(self.currentPresetKey);

        synthArgs = [
            \out, self.engine.audioBus,
            \gate, 1,
            \f, fCarrier,
            \amp, (velocity / 127.0).squared // Curva de velocidad musical
        ] ++ presetArgs;

        // 4. Instanciar el sinte en el grupo seguro del motor
        self.activeVoices[voiceKey] = Synth.head(
            self.engine.synthGroup,
            \fmVoice,
            synthArgs
        );
    },

    // Liberación de nota polifónica segura
    noteOff: { |self, noteNumber, channel = 0|
        var voiceKey = (channel.asString ++ "_" ++ noteNumber.asString).asSymbol;
        var synth = self.activeVoices[voiceKey];

        if(synth.notNil) {
            synth.set(\gate, 0); // Dispara la fase de release del envelope
            self.activeVoices[voiceKey] = nil;
        };
    },

    // Pánico Suave: envía gate 0 a todas las voces activas respetando el release
    panicSoft: { |self|
        self.engine.synthGroup.set(\gate, 0);
        self.activeVoices.clear;
        "Pánico Suave: todas las notas liberadas hacia fase release.".postln;
    },

    // Pánico Duro: destruye inmediatamente todos los sintes en el servidor
    panicHard: { |self|
        self.engine.synthGroup.freeAll;
        self.activeVoices.clear;
        "Pánico Duro: corte instantáneo de todos los sintes.".postln;
    }
);

voiceManagerModule;
