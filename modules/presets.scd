/*
    SCMicroSynth - Module: Presets
    Administra la carga, almacenamiento e interpolación de presets de síntesis FM.
*/

var presetsModule = (
    bank: IdentityDictionary.new,
    currentPreset: nil,

    init: { |self, defaultPath|
        var path = defaultPath ? (thisProcess.nowExecutingPath.dirname +/+ "../presets/default_presets.scd");
        if(File.exists(path)) {
            self.loadBankFromFile(path);
        };
        self;
    },

    loadBankFromFile: { |self, path|
        var loaded = path.load;
        if(loaded.isKindOf(Dictionary) or: { loaded.isKindOf(Event) }) {
            loaded.keysValuesDo { |k, v|
                self.bank[k.asSymbol] = v;
            };
            ("Banco de presets cargado exitosamente desde: " ++ path).postln;
        } {
            ("Error al cargar presets desde: " ++ path).warn;
        };
    },

    getPreset: { |self, key|
        var p = self.bank[key.asSymbol];
        if(p.isNil) {
            ("Advertencia: Preset '" ++ key ++ "' no existe en el banco.").warn;
            p = self.bank[\fmBell]; // Fallback
        };
        p;
    },

    setPreset: { |self, key, dict|
        self.bank[key.asSymbol] = dict;
        ("Preset guardado: " ++ key).postln;
    },

    listPresets: { |self|
        self.bank.keys.asArray.sort;
    },

    // Convierte un preset a un array de argumentos apto para Synth / Node.set
    asArgsArray: { |self, presetKey|
        var preset = self.getPreset(presetKey);
        var args = List.new;
        preset.keysValuesDo { |param, val|
            if(param != \name) {
                args.add(param);
                args.add(val);
            };
        };
        args.asArray;
    }
);

presetsModule;
