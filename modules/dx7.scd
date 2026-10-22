/*
    diesisRosa - Module: DX7 Microtonal Engine
    Adaptación de la arquitectura clásica de 6 operadores de Yamaha DX7
    a la síntesis microtonal en SuperCollider estándar (sin requerir plugins externos).

    Referencias de diseño:
    - Chowning & Bristow (1986): "FM Theory & Applications".
    - Yamaha DX7 Operation Manual (32 Algorithms matrix & envelope rates).
    - Mads Kjeldgaard / Aziz Ege Gonul (DX7-Supercollider).
*/

var dx7Module = (
    // Definición canónica de los 32 algoritmos del DX7
    // Cada algoritmo define qué operadores son carriers (salen al bus de audio)
    // y la topología de modulación de los 6 operadores.
    // En DX7: 1-indexed, Op 1 suele ser carrier inferior.
    algorithms: (
        1: (carriers: [1, 3], modulators: [[2, 1], [6, 6], [6, 5], [5, 4], [4, 3]]),
        2: (carriers: [1, 3], modulators: [[2, 1], [2, 2], [6, 5], [5, 4], [4, 3]]),
        3: (carriers: [1, 4], modulators: [[2, 1], [3, 2], [6, 6], [6, 5], [5, 4]]),
        4: (carriers: [1, 4], modulators: [[2, 1], [3, 2], [6, 4], [6, 6], [5, 4]]),
        5: (carriers: [1, 3, 5], modulators: [[2, 1], [4, 3], [6, 6], [6, 5]]),
        6: (carriers: [1, 3, 5], modulators: [[2, 1], [4, 3], [6, 5], [5, 5]]),
        7: (carriers: [1, 3], modulators: [[2, 1], [4, 3], [5, 3], [6, 6], [6, 5]]),
        8: (carriers: [1, 3], modulators: [[2, 1], [4, 3], [5, 3], [4, 4], [6, 5]]),
        9: (carriers: [1, 3], modulators: [[2, 1], [2, 2], [4, 3], [5, 3], [6, 5]]),
        10: (carriers: [1, 4], modulators: [[2, 1], [3, 1], [5, 4], [6, 4], [3, 3]]),
        11: (carriers: [1, 4], modulators: [[2, 1], [3, 1], [5, 4], [6, 4], [6, 6]]),
        12: (carriers: [1, 3], modulators: [[2, 1], [2, 2], [4, 3], [5, 3], [6, 3]]),
        13: (carriers: [1, 3], modulators: [[2, 1], [4, 3], [5, 3], [6, 3], [6, 6]]),
        14: (carriers: [1, 3], modulators: [[2, 1], [4, 3], [5, 4], [6, 4], [6, 6]]),
        15: (carriers: [1, 3], modulators: [[2, 1], [2, 2], [4, 3], [5, 4], [6, 4]]),
        16: (carriers: [1], modulators: [[2, 1], [3, 1], [5, 1], [4, 3], [6, 5], [6, 6]]),
        17: (carriers: [1], modulators: [[2, 1], [3, 1], [5, 1], [4, 3], [6, 5], [2, 2]]),
        18: (carriers: [1], modulators: [[2, 1], [3, 1], [4, 1], [3, 2], [5, 4], [6, 5], [3, 3]]),
        19: (carriers: [1, 4, 5], modulators: [[2, 1], [3, 2], [6, 4], [6, 5], [6, 6]]),
        20: (carriers: [1, 2, 4], modulators: [[3, 1], [3, 2], [3, 3], [5, 4], [6, 4]]),
        21: (carriers: [1, 2, 4, 5], modulators: [[3, 1], [3, 2], [3, 3], [6, 4], [6, 5]]),
        22: (carriers: [1, 3, 4, 5], modulators: [[2, 1], [6, 3], [6, 4], [6, 5], [6, 6]]),
        23: (carriers: [1, 2, 4, 5], modulators: [[3, 2], [6, 4], [6, 5], [6, 6]]),
        24: (carriers: [1, 2, 3, 4, 5], modulators: [[6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6]]),
        25: (carriers: [1, 2, 3, 4, 5], modulators: [[6, 4], [6, 5], [6, 6]]),
        26: (carriers: [1, 2, 4], modulators: [[3, 2], [5, 4], [6, 4], [6, 6]]),
        27: (carriers: [1, 2, 4], modulators: [[3, 2], [3, 3], [5, 4], [6, 4]]),
        28: (carriers: [1, 3, 6], modulators: [[2, 1], [4, 3], [5, 4], [5, 5]]),
        29: (carriers: [1, 2, 3, 5], modulators: [[4, 3], [6, 5], [6, 6]]),
        30: (carriers: [1, 2, 3, 6], modulators: [[4, 3], [5, 4], [5, 5]]),
        31: (carriers: [1, 2, 3, 4, 5], modulators: [[6, 5], [6, 6]]),
        32: (carriers: [1, 2, 3, 4, 5, 6], modulators: [[6, 6]]) // Síntesis aditiva pura + feedback en op 6
    ),

    listAlgorithms: { |self|
        (1..32);
    },

    getAlgorithm: { |self, num|
        self.algorithms[num.asInteger] ? self.algorithms[1];
    },

    // Convierte tasas (rates 0-99) de envolvente DX7 a segundos de SuperCollider
    rateToSeconds: { |self, rate|
        var r = rate.clip(0, 99);
        // Aproximación logarítmica estándar de curvas DX7 (39.6s a nivel 0 hasta 0.001s a nivel 99)
        (0.001 * (1.12.pow(99 - r))).clip(0.001, 30.0);
    },

    // Convierte niveles (levels 0-99) de envolvente DX7 a amplitud lineal (0.0 a 1.0)
    levelToAmp: { |self, level|
        var l = level.clip(0, 99);
        (l / 99.0).squared;
    },

    // Genera parámetros de voz listos para sintetizar microtonalmente
    buildVoiceParams: { |self, algo = 1, fundamental = 440.0, ratios|
        var algData = self.getAlgorithm(algo);
        var opRatios = ratios ? [1, 1, 1, 1, 1, 1];
        var opFreqs = opRatios.collect({ |r| fundamental * r });

        (
            algorithm: algo,
            carriers: algData[\carriers],
            modulators: algData[\modulators],
            frequencies: opFreqs
        );
    }
);

dx7Module;
