/*
    SCMicroSynth - Module: Tunings
    Encapsula el catálogo de 10 afinaciones microtonales y temperamentos históricos.
    Calcula arrays de frecuencias (384 posiciones para abarcar 3 canales MIDI).
*/

var tuningModule = (
    scales: IdentityDictionary.new,
    referenceFreq: 440.0,

    init: { |self|
        self.buildAllScales;
        self;
    },

    // 1. Temperamento Igual de 31 divisiones (31-TET)
    build31TET: { |self, refFreq = 440.0, refNote = 124, total = 384|
        var stepRatio = 2.pow(1/31);
        Array.fill(total, { |i|
            var distance = i - refNote;
            refFreq * (stepRatio.pow(distance));
        });
    },

    // 2. Temperamento Igual de 41 divisiones (41-TET)
    build41TET: { |self, refFreq = 440.0, refNote = 164, total = 384|
        var stepRatio = 2.pow(1/41);
        Array.fill(total, { |i|
            var distance = i - refNote;
            refFreq * (stepRatio.pow(distance));
        });
    },

    // 3. Temperamento Igual de 53 divisiones (53-TET)
    build53TET: { |self, refFreq = 440.0, refNote = 212, total = 384|
        var stepRatio = 2.pow(1/53);
        Array.fill(total, { |i|
            var distance = i - refNote;
            refFreq * (stepRatio.pow(distance));
        });
    },

    // 4. Temperamento Igual estándar de 12 divisiones (12-TET)
    build12TET: { |self, refFreq = 440.0, refNote = 69, total = 384|
        var stepRatio = 2.pow(1/12);
        Array.fill(total, { |i|
            var distance = i - refNote;
            refFreq * (stepRatio.pow(distance));
        });
    },

    // 5. Afinación Pitagórica acomodada en 53edo
    buildPitag53: { |self, refFreq = 440.0, total = 384|
        var pitag = Array.newClear(53);
        var offset, f0;

        pitag.put(40, 1.0); // Grado 40 (nota La) como punto de partida

        // 26 quintas ascendentes
        (1..26).do { |k|
            var prevPc = (40 + ((k - 1) * 31)) % 53;
            var currentPc = (40 + (k * 31)) % 53;
            var ratio = pitag.at(prevPc) * (3/2);
            while { ratio >= 2.0 } { ratio = ratio / 2.0 };
            pitag.put(currentPc, ratio);
        };

        // 26 cuartas ascendentes (quintas descendentes)
        (1..26).do { |k|
            var prevPc = (40 + ((k - 1) * 22)) % 53;
            var currentPc = (40 + (k * 22)) % 53;
            var ratio = pitag.at(prevPc) * (4/3);
            while { ratio >= 2.0 } { ratio = ratio / 2.0 };
            pitag.put(currentPc, ratio);
        };

        // Normalización de octava: PC 0 base 1.0
        offset = pitag.at(0);
        53.do { |i|
            var newRatio = pitag.at(i) / offset;
            if(newRatio < 1.0) { newRatio = newRatio * 2.0 };
            pitag.put(i, newRatio);
        };

        f0 = refFreq / (pitag.at(40) * (2 ** 4));

        Array.fill(total, { |i|
            var virtualIndex = i + 40;
            var pc = virtualIndex % 53;
            var octave = virtualIndex div: 53;
            f0 * pitag.at(pc) * (2 ** octave);
        });
    },

    // 6. Mesotónico 1/4 de comma acomodado en 31edo
    buildMeantone31: { |self, refFreq = 440.0, total = 384|
        var mean31 = Array.newClear(31);
        var qMeantone = (3/2) / ((81/80).pow(1/4));
        var offset, f0;

        mean31.put(23, 1.0);

        (1..15).do { |k|
            var prevPc = (23 + ((k - 1) * 18)) % 31;
            var currentPc = (23 + (k * 18)) % 31;
            var ratio = mean31.at(prevPc) * qMeantone;
            while { ratio >= 2.0 } { ratio = ratio / 2.0 };
            mean31.put(currentPc, ratio);
        };

        (1..15).do { |k|
            var prevPc = (23 + ((k - 1) * 13)) % 31;
            var currentPc = (23 + (k * 13)) % 31;
            var ratio = mean31.at(prevPc) * (2.0 / qMeantone);
            while { ratio >= 2.0 } { ratio = ratio / 2.0 };
            mean31.put(currentPc, ratio);
        };

        offset = mean31.at(0);
        31.do { |i|
            var newRatio = mean31.at(i) / offset;
            if(newRatio < 1.0) { newRatio = newRatio * 2.0 };
            mean31.put(i, newRatio);
        };

        f0 = refFreq / (mean31.at(23) * (2 ** 4));

        Array.fill(total, { |i|
            var virtualIndex = i + 23;
            var pc = virtualIndex % 31;
            var octave = virtualIndex div: 31;
            f0 * mean31.at(pc) * (2 ** octave);
        });
    },

    // 7. Temperamento Mágico acomodado en 41edo
    buildMagic41: { |self, refFreq = 440.0, total = 384|
        var generator = 3.pow(1/5);
        var stepRatio = generator.pow(1/13);
        Array.fill(total, { |i|
            var distance = i - 164;
            refFreq * (stepRatio.pow(distance));
        });
    },

    // 8. Harry Partch 43 tonos (Justa Entonación)
    buildPartch43: { |self, f0 = 24.5, total = 384|
        var ratios = [
            1/1, 81/80, 33/32, 21/20, 16/15, 12/11, 11/10, 10/9, 9/8, 8/7,
            7/6, 32/27, 6/5, 11/9, 5/4, 14/11, 9/7, 21/16, 4/3, 27/20,
            11/8, 7/5, 10/7, 16/11, 40/27, 3/2, 32/21, 14/9, 11/7, 8/5,
            18/11, 5/3, 27/16, 12/7, 7/4, 16/9, 9/5, 20/11, 11/6, 15/8,
            40/21, 64/33, 160/81
        ];
        Array.fill(total, { |i|
            var ratioIndex = i % 43;
            var octave = i div: 43;
            f0 * ratios[ratioIndex] * (2 ** octave);
        });
    },

    // 9. D'Alessandro de Erv Wilson
    buildDalessandro: { |self, total = 384|
        var freqOct4 = [
            (1)*(2.pow(8)), (3*7*9*11)/(2.pow(3)), (3*11)*(2.pow(3)), (3*5*9)*(2),
            (3.pow(2)*5*9*11)/(2.pow(4)), (7*11/9)*(2.pow(5)), (5*7)*(2.pow(3)), (9)*(2.pow(5)),
            (3*5*7*11)/(2.pow(2)), (3*9*11)*(2.pow(0)), (7/3)*(2.pow(7)), (9*3*5*9)/(2.pow(2)),
            (7*11)*(2.pow(2)), (5*7*9)*(2.pow(0)), (5)*(2.pow(6)), (3*5*7*9*11)/(2.pow(5)),
            (3*5*11)*(2), (3*7)*(2.pow(4)), (3*5*7*9/11)*(2.pow(2)), (1/3)*(2.pow(10)),
            (7*9*11)/(2), (11)*(2.pow(5)), (5*9)*(2.pow(3)), (3*5*9*11)/(2.pow(2)),
            (3*7*9)*(2), (3)*(2.pow(7)), (5*7*11)*(2.pow(0)), (9*11)*(2.pow(2)),
            (3.pow(2)*5*9)*(2.pow(0)), (7*11/3)*(2.pow(4)), (3*5*7)*(2.pow(2)), (3*9)*(2.pow(4)),
            (5*7*9*11)/(2.pow(3)), (5*11)*(2.pow(3)), (7)*(2.pow(6)), (3*7*11)*(2),
            (3*5*7*9)/(2), (3*5)*(2.pow(5)), (11.pow(2))*(2.pow(2)), (3.pow(2)*5*7*9*11)/(2.pow(6)),
            (5*9*11)*(2.pow(0)), (7*9)*(2.pow(3))
        ];
        Array.fill(total, { |i|
            var grado = i % 42;
            var octave = i div: 42;
            freqOct4[grado] * (2 ** (octave - 4));
        });
    },

    // 10. Centaur de Kraig Grady (12 tonos, Justa Entonación límite 7)
    buildCentaur: { |self, refFreq = 440.0, refMidi = 69, total = 384|
        var ratiosCentaur = [ 1/1, 21/20, 9/8, 7/6, 5/4, 4/3, 7/5, 3/2, 14/9, 5/3, 7/4, 15/8 ];
        var refDegree = refMidi % 12;
        var refOctave = refMidi div: 12;
        var f0 = refFreq / ratiosCentaur[refDegree] / (2 ** refOctave);

        Array.fill(total, { |i|
            var ratioIndex = i % 12;
            var octave = i div: 12;
            f0 * ratiosCentaur[ratioIndex] * (2 ** octave);
        });
    },

    // Generar todas las tablas y almacenarlas en el catálogo
    buildAllScales: { |self|
        self.scales[\tet31] = self.build31TET;
        self.scales[\tet41] = self.build41TET;
        self.scales[\tet53] = self.build53TET;
        self.scales[\tet12] = self.build12TET;
        self.scales[\pitag53] = self.buildPitag53;
        self.scales[\meantone31] = self.buildMeantone31;
        self.scales[\magic41] = self.buildMagic41;
        self.scales[\partch] = self.buildPartch43;
        self.scales[\dalessandro] = self.buildDalessandro;
        self.scales[\centaur] = self.buildCentaur;
    },

    // Interfaz pública para obtener una escala por clave
    getScale: { |self, key|
        var scale = self.scales[key.asSymbol];
        if(scale.isNil) {
            ("Advertencia: Escala '" ++ key ++ "' no encontrada. Usando tet12 por defecto.").warn;
            scale = self.scales[\tet12];
        };
        scale;
    },

    listScales: { |self|
        self.scales.keys.asArray.sort;
    }
);

tuningModule.init;
