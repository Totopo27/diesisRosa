/*
    diesisRosa - Banco de Presets Barry Truax
    Colección basada en la teoría de Forma Normal (N.F.) y familias de ratios C:M
    desarrolladas por Barry Truax en Simon Fraser University (1977-1978).

    Referencias de diseño:
    - Truax, B. (1977). "Organizational Techniques for C:M Ratios in Frequency Modulation".
    - Truax, B. (1999). "Handbook for Acoustic Ecology".
*/

(
    // 1. Familia Inarmónica 2:5 (Forma Normal)
    // Bandas laterales asimétricas con espaciamiento 2C (4) y M-2C (1).
    // Produce un espectro de placa percusiva metálica y gong de afinación fija.
    truaxGong2_5: (
        name: "Truax 2:5 Inharmonic Gong",
        c: 2, m1: 5, i_m2: 1,
        i1: 3.5, i_i2: 1.2,
        cDt: 0.0, cAt: 0.002, cDe: 3.2, cSu: 0.0, cRe: 3.2, cCurv: -5,
        m1At: 0.001, m1De: 1.8, m1Su: 0.0, m1Re: 1.8, m1Curv: -6,
        i_m2At: 0.001, i_m2De: 0.8, i_m2Su: 0.0, i_m2Re: 0.8, i_m2Curv: -7,
        fVib: 0, aVib: 0, tVib: 0
    ),

    // 2. Familia Inarmónica 3:7 (Forma Normal)
    // Ratios C:M = 3:7 con componentes reflejados en contrafase.
    // Timbre cristalino de campana tubular de vidrio para acordes microtonales lentos.
    truaxChime3_7: (
        name: "Truax 3:7 Glass Chime",
        c: 3, m1: 7, i_m2: 2,
        i1: 2.8, i_i2: 1.5,
        cDt: 0.01, cAt: 0.02, cDe: 2.8, cSu: 0.05, cRe: 2.4, cCurv: -4,
        m1At: 0.01, m1De: 1.4, m1Su: 0.0, m1Re: 1.4, m1Curv: -5,
        i_m2At: 0.005, i_m2De: 0.5, i_m2Su: 0.0, i_m2Re: 0.5, i_m2Curv: -6,
        fVib: 4.0, aVib: 0.3, tVib: 0.8
    ),

    // 3. Familia 1:2 / 3:2 (Armónicos Impares Puros)
    // Timbre tipo caña hueca o clarinete. Al contener sólo impares,
    // armoniza limpiamente en temperamentos de terceras puras (meantone31 y centaur).
    truaxHollowReed: (
        name: "Truax 1:2 Hollow Reed",
        c: 1, m1: 2, i_m2: 1,
        i1: 2.2, i_i2: 0.8,
        cDt: 0.0, cAt: 0.04, cDe: 0.8, cSu: 0.45, cRe: 0.6, cCurv: -2,
        m1At: 0.05, m1De: 0.6, m1Su: 0.3, m1Re: 0.5, m1Curv: -3,
        i_m2At: 0.02, i_m2De: 0.3, i_m2Su: 0.1, i_m2Re: 0.3, i_m2Curv: -4,
        fVib: 5.2, aVib: 0.8, tVib: 0.4
    ),

    // 4. Miembro desplazado de la familia 1:1 (Carrier alto 3:1)
    // Según Truax, usar un miembro alto de una familia armónica concentra
    // la energía en una región formántica aguda sin perder la fundamental base.
    truaxFormantVocal: (
        name: "Truax Formant Vowel (3:1 Family)",
        c: 3, m1: 1, i_m2: 2,
        i1: 1.8, i_i2: 1.0,
        cDt: 0.02, cAt: 0.15, cDe: 0.9, cSu: 0.6, cRe: 1.2, cCurv: -2,
        m1At: 0.18, m1De: 0.7, m1Su: 0.5, m1Re: 1.0, m1Curv: -2,
        i_m2At: 0.1, i_m2De: 0.4, i_m2Su: 0.3, i_m2Re: 0.8, i_m2Curv: -3,
        fVib: 4.8, aVib: 1.2, tVib: 0.6
    ),

    // 5. Textura acústica en la frontera sub-audio (20 Hz)
    // Inspirado en el Handbook for Acoustic Ecology:
    // Transición continua entre pulso estocástico y timbre continuo.
    truaxWaterDroplet: (
        name: "Truax Acoustic Ecology Drop",
        c: 1, m1: 1.4, i_m2: 0.5,
        i1: 3.8, i_i2: 2.5,
        cDt: 0.0, cAt: 0.005, cDe: 1.2, cSu: 0.0, cRe: 1.2, cCurv: -6,
        m1At: 0.002, m1De: 0.5, m1Su: 0.0, m1Re: 0.5, m1Curv: -7,
        i_m2At: 0.001, i_m2De: 0.25, i_m2Su: 0.0, i_m2Re: 0.25, i_m2Curv: -8,
        fVib: 16.0, aVib: 4.0, tVib: 0.2
    )
);
