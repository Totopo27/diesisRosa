/*
    =========================================================================
    diesisRosa - Plantilla de Banco de Presets de Usuario (user_presets.example.scd)
    =========================================================================
    Para crear tu propio banco persistente de sonidos:
    1. Copia este archivo como 'presets/user_presets.scd'
    2. Modifica o añade tus propios timbres en la estructura de abajo.
    3. Al iniciar 'main.scd', el archivo será cargado automáticamente por el
       módulo de presets y estará disponible inmediatamente mediante:
           ~diesisRosa.setPreset(\miLeadMicrotonal);

    =========================================================================
    ANATOMÍA Y CONTRATO DE UN PRESET FM (3 Operadores en Cascada):
    Modulador 2 (i_m2) -> Modulador 1 (m1) -> Portadora / Carrier (c)
    =========================================================================
    - name:       Nombre descriptivo para visualización.
    - c:          Ratio de frecuencia del Carrier (portadora).
    - m1:         Ratio de frecuencia del Modulador 1.
    - i_m2:       Ratio de frecuencia del Modulador 2.
    - i1:         Índice de modulación de Mod1 sobre Carrier (profundidad tímbrica).
    - i_i2:       Índice de modulación de Mod2 sobre Mod1 (complejidad armónica).
    - cDt:        Carrier Delay Time (tiempo de retraso antes del ataque, s).
    - cAt, cDe:   Carrier Attack y Decay time (segundos).
    - cSu, cRe:   Carrier Sustain (amplitud 0.0 - 1.0) y Release time (segundos).
    - cCurv:      Curvatura del envolvente de Carrier (-4 exponencial típica).
    - m1At..m1Re: Envolvente ADSR para Modulador 1 (control de brillo dinámico).
    - m1Curv:     Curvatura de envolvente Modulador 1.
    - i_m2At..Re: Envolvente ADSR para Modulador 2.
    - i_m2Curv:   Curvatura de envolvente Modulador 2.
    - fVib:       Frecuencia del LFO de vibrato (Hz).
    - aVib:       Profundidad del vibrato.
    - tVib:       Tiempo de retardo / rampa de entrada del vibrato (segundos).
    =========================================================================
*/

(
    // ---------------------------------------------------------------------
    // 1. Lead Solista Microtonal (Penetrante, rico en armónicos impares y vibrato expresivo)
    // ---------------------------------------------------------------------
    miLeadMicrotonal: (
        name: "Microtonal Soloist Lead",

        // Ratios: C=1, M1=3, M2=5 (estructura armónica impar, carácter cortante y vocal)
        c: 1, m1: 3, i_m2: 5,

        // Índices de modulación
        i1: 3.2,       // Brillo pronunciado en el primer modulador
        i_i2: 1.8,     // Textura rica y brillante inyectada por el modulador 2

        // Envolvente de Amplitud (Portadora / Carrier - DADSR)
        cDt: 0.0,      // Sin delay inicial
        cAt: 0.02,     // Ataque ágil pero sin clicks
        cDe: 0.6,      // Caída moderada hacia sustain
        cSu: 0.75,     // Nivel de mantenimiento firme para solos sostenidos
        cRe: 0.4,      // Release limpio para articulación melódica
        cCurv: -3,     // Caída exponencial natural

        // Envolvente de Timbre Mod1 (ADSR)
        m1At: 0.04,
        m1De: 0.8,
        m1Su: 0.45,
        m1Re: 0.35,
        m1Curv: -4,

        // Envolvente de Timbre Mod2 (ADSR - transitorio de articulación)
        i_m2At: 0.01,
        i_m2De: 0.25,
        i_m2Su: 0.15,
        i_m2Re: 0.2,
        i_m2Curv: -5,

        // Vibrato expresivo retardado
        fVib: 5.5,     // 5.5 Hz (velocidad clásica de legato)
        aVib: 0.8,     // Desviación moderada
        tVib: 0.6      // Entra progresivamente tras 600 ms
    ),

    // ---------------------------------------------------------------------
    // 2. Sub-Bajo Profundo Microtonal (Poderoso en bajas frecuencias, ataque percusivo)
    // ---------------------------------------------------------------------
    miBajoSub: (
        name: "Deep Sub Bass FM",

        // Ratios: C=1 (fundamental sólida), M1=0.5 (octava sub-grave), M2=1 (refuerzo)
        c: 1, m1: 0.5, i_m2: 1,

        // Índices de modulación
        i1: 2.4,       // Modulación densa para generar cuerpo cálido
        i_i2: 1.2,     // Mordisco inicial metálico en el ataque

        // Envolvente de Amplitud (Portadora / Carrier - DADSR)
        cDt: 0.0,
        cAt: 0.005,    // Ataque percusivo rápido
        cDe: 0.8,
        cSu: 0.35,
        cRe: 0.25,     // Desvanecimiento controlado sin desbordamiento de frecuencias bajas
        cCurv: -4,

        // Envolvente Mod1 (Cuerpo del bajo)
        m1At: 0.005,
        m1De: 0.5,
        m1Su: 0.2,
        m1Re: 0.2,
        m1Curv: -4,

        // Envolvente Mod2 (Punzón transitorio en el ataque)
        i_m2At: 0.001,
        i_m2De: 0.1,
        i_m2Su: 0.0,   // Cae a cero para mantener el bajo limpio en sustain
        i_m2Re: 0.1,
        i_m2Curv: -6,

        // Sin vibrato para garantizar estabilidad tonal estricta en el registro grave
        fVib: 0, aVib: 0, tVib: 0
    ),

    // ---------------------------------------------------------------------
    // 3. Pad Galáctico Atmosférico (Evolución tímbrica lenta y batimiento microtonal)
    // ---------------------------------------------------------------------
    miPadGalactico: (
        name: "Galactic Shimmer Pad",

        // Ratios micro-desafinados para generar shimmer y batimiento acústico interno
        c: 1, m1: 2.007, i_m2: 0.7071,

        // Índices de modulación
        i1: 1.6,       // Brillo sutil y continuo
        i_i2: 2.2,     // Textura cristalina compleja en altas frecuencias

        // Envolvente de Amplitud (Portadora / Carrier - DADSR)
        cDt: 0.05,     // Leve retardo espacial
        cAt: 1.5,      // Entrada envolvente y etérea (fade-in gradual)
        cDe: 2.0,
        cSu: 0.85,     // Nivel de mantenimiento prominente para acordes densos
        cRe: 3.5,      // Cola de liberación espaciosa
        cCurv: -2,

        // Envolvente Mod1 (Apertura tímbrica progresiva)
        m1At: 2.0,
        m1De: 1.8,
        m1Su: 0.6,
        m1Re: 3.0,
        m1Curv: -2,

        // Envolvente Mod2 (Ondulación espectral continua)
        i_m2At: 1.2,
        i_m2De: 2.5,
        i_m2Su: 0.5,
        i_m2Re: 2.8,
        i_m2Curv: -2,

        // Vibrato espacial amplio y lento
        fVib: 3.8,     // LFO lento
        aVib: 1.4,     // Modulación de tono envolvente
        tVib: 1.2      // Despliegue tardío
    )
)
