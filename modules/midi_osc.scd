/*
    SCMicroSynth - Module: MIDI & OSC Controller
    Mapea entradas MIDI (canales 0, 1, 2) y OSC (/mnote, /allnotesoff, etc.)
    despachando limpiamente al Voice Manager.
*/

var midiOscModule = (
    voiceManager: nil,
    oscDefs: List.new,
    midiDefs: List.new,

    init: { |self, voiceMgr|
        self.voiceManager = voiceMgr;
        self.setupOSC;
        self.setupMIDI;
        self;
    },

    setupOSC: { |self|
        // Liberar listeners previos si existían
        self.cleanupOSC;

        // Nota OSC (/mnote)
        self.oscDefs.add(
            OSCdef(\scMicro_note, { |msg|
                var noteNum = msg[1].asInteger;
                var velOrGate = msg[2].asFloat;

                if(velOrGate > 0) {
                    self.voiceManager.noteOn(noteNum, velOrGate, 0);
                } {
                    self.voiceManager.noteOff(noteNum, 0);
                };
            }, '/mnote')
        );

        // Transposición de octava (/param/a/octave)
        self.oscDefs.add(
            OSCdef(\scMicro_octave, { |msg|
                var oct = msg[1].asInteger;
                self.voiceManager.setOctaveShift(oct);
            }, '/param/a/octave')
        );

        // Cambio de escala microtonal vía OSC (/param/scale)
        self.oscDefs.add(
            OSCdef(\scMicro_scale, { |msg|
                var scaleKey = msg[1].asSymbol;
                self.voiceManager.setScale(scaleKey);
            }, '/param/scale')
        );

        // Cambio de preset FM vía OSC (/param/preset)
        self.oscDefs.add(
            OSCdef(\scMicro_preset, { |msg|
                var presetKey = msg[1].asSymbol;
                self.voiceManager.setPreset(presetKey);
            }, '/param/preset')
        );

        // Pánico suave y duro vía OSC
        self.oscDefs.add(
            OSCdef(\scMicro_panicSoft, {
                self.voiceManager.panicSoft;
            }, '/allnotesoff')
        );

        self.oscDefs.add(
            OSCdef(\scMicro_panicHard, {
                self.voiceManager.panicHard;
            }, '/allsoundoff')
        );

        "Receptores OSC configurados en puerto por defecto.".postln;
    },

    setupMIDI: { |self|
        self.cleanupMIDI;

        // Inicializar MIDI si no está conectado
        if(MIDIClient.initialized.not) {
            MIDIClient.init(verbose: false);
            MIDIIn.connectAll;
        };

        // NoteOn para Canales 0, 1 y 2 con offset de teclado microtonal (0, 128, 256)
        self.midiDefs.add(
            MIDIdef.noteOn(\scMicro_midiOn, { |vel, nn, chan|
                var offset = case
                    { chan == 0 } { 0 }
                    { chan == 1 } { 128 }
                    { chan == 2 } { 256 }
                    { 0 };
                self.voiceManager.noteOn(nn + offset, vel, chan);
            })
        );

        // NoteOff
        self.midiDefs.add(
            MIDIdef.noteOff(\scMicro_midiOff, { |vel, nn, chan|
                var offset = case
                    { chan == 0 } { 0 }
                    { chan == 1 } { 128 }
                    { chan == 2 } { 256 }
                    { 0 };
                self.voiceManager.noteOff(nn + offset, chan);
            })
        );

        // Control Change (CC 120 = All Sound Off, CC 123 = All Notes Off)
        self.midiDefs.add(
            MIDIdef.cc(\scMicro_midiCC, { |val, num, chan|
                case
                { num == 123 } { self.voiceManager.panicSoft }
                { num == 120 } { self.voiceManager.panicHard };
            })
        );

        "Controladores MIDI enlazados (Canales 1, 2 y 3 para microtonalidad extendida).".postln;
    },

    cleanupOSC: { |self|
        self.oscDefs.do(_.free);
        self.oscDefs.clear;
    },

    cleanupMIDI: { |self|
        self.midiDefs.do(_.free);
        self.midiDefs.clear;
    },

    cleanup: { |self|
        self.cleanupOSC;
        self.cleanupMIDI;
    }
);

midiOscModule;
