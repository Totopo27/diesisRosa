/*
    diesisRosa - Presets Canónicos Yamaha DX7
    Reconstrucción de parches icónicos del DX7 adaptados a síntesis microtonal.
*/

(
    // 1. E.PIANO 1 (El piano eléctrico más famoso de la historia de la música pop)
    // Algoritmo 5 / Algoritmo 16 según variaciones (aquí adaptado a ratios microtonales)
    dx7EPIANO: (
        name: "Yamaha DX7 E.PIANO 1 (Rom 1A)",
        algorithm: 5,
        ratios: [1.0, 14.0, 1.0, 1.0, 1.0, 1.0], // Op1 (Carrier), Op2 (Modulador de ataque metálico en 14x)
        c: 1, m1: 1, i_m2: 14,
        i1: 2.4, i_i2: 1.1,
        cDt: 0.0, cAt: 0.005, cDe: 2.2, cSu: 0.15, cRe: 1.1, cCurv: -3,
        m1At: 0.002, m1De: 1.0, m1Su: 0.1, m1Re: 0.9, m1Curv: -4,
        i_m2At: 0.001, i_m2De: 0.18, i_m2Su: 0.0, i_m2Re: 0.15, i_m2Curv: -6,
        fVib: 4.8, aVib: 0.4, tVib: 0.8
    ),

    // 2. BASS 1 (El bajo seco y percusivo del DX7)
    dx7BASS1: (
        name: "Yamaha DX7 BASS 1",
        algorithm: 1,
        ratios: [0.5, 0.5, 1.0, 1.0, 1.0, 1.0],
        c: 1, m1: 1, i_m2: 2,
        i1: 3.8, i_i2: 2.0,
        cDt: 0.0, cAt: 0.003, cDe: 0.7, cSu: 0.08, cRe: 0.35, cCurv: -4,
        m1At: 0.002, m1De: 0.45, m1Su: 0.02, m1Re: 0.25, m1Curv: -5,
        i_m2At: 0.001, i_m2De: 0.18, i_m2Su: 0.0, i_m2Re: 0.15, i_m2Curv: -6,
        fVib: 0, aVib: 0, tVib: 0
    ),

    // 3. TUB BELLS (Campanas tubulares sinfónicas del banco ROM 1A)
    dx7TUBBELLS: (
        name: "Yamaha DX7 TUB BELLS",
        algorithm: 1,
        ratios: [1.0, 3.47, 1.0, 1.41, 1.0, 1.0],
        c: 1, m1: 3.47, i_m2: 1.41,
        i1: 4.8, i_i2: 2.2,
        cDt: 0.0, cAt: 0.002, cDe: 3.5, cSu: 0.0, cRe: 3.5, cCurv: -4,
        m1At: 0.001, m1De: 1.5, m1Su: 0.0, m1Re: 1.5, m1Curv: -6,
        i_m2At: 0.001, i_m2De: 0.7, i_m2Su: 0.0, i_m2Re: 0.7, i_m2Curv: -8,
        fVib: 0, aVib: 0, tVib: 0
    ),

    // 4. MARIMBA (Percusión melódica con transitorio de mazo de fieltro)
    dx7MARIMBA: (
        name: "Yamaha DX7 MARIMBA",
        algorithm: 8,
        ratios: [1.0, 4.0, 1.0, 1.0, 1.0, 1.0],
        c: 1, m1: 4, i_m2: 1,
        i1: 3.2, i_i2: 0.8,
        cDt: 0.0, cAt: 0.001, cDe: 0.8, cSu: 0.0, cRe: 0.8, cCurv: -6,
        m1At: 0.001, m1De: 0.25, m1Su: 0.0, m1Re: 0.25, m1Curv: -8,
        i_m2At: 0.001, i_m2De: 0.1, i_m2Su: 0.0, i_m2Re: 0.1, i_m2Curv: -9,
        fVib: 0, aVib: 0, tVib: 0
    ),

    // 5. BRASS 1 (El conjunto de metales brillante característico de los 80s)
    dx7BRASS1: (
        name: "Yamaha DX7 BRASS 1",
        algorithm: 1,
        ratios: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
        c: 1, m1: 1, i_m2: 1,
        i1: 3.0, i_i2: 1.5,
        cDt: 0.0, cAt: 0.08, cDe: 0.6, cSu: 0.6, cRe: 0.45, cCurv: -2,
        m1At: 0.12, m1De: 0.5, m1Su: 0.5, m1Re: 0.4, m1Curv: -2,
        i_m2At: 0.10, i_m2De: 0.3, i_m2Su: 0.4, i_m2Re: 0.3, i_m2Curv: -3,
        fVib: 5.5, aVib: 0.8, tVib: 0.5
    )
);
