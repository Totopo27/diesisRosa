/*
    SCMicroSynth - Default Presets
    Definiciones de timbres FM clásicos y experimentales.
*/

(
    // 1. Campana Metálica / Tubular Bell (FM Clásico con ratios inarmónicos)
    fmBell: (
        name: "FM Tubular Bell",
        c: 1, m1: 3.5, i_m2: 1.414,
        i1: 4.5, i_i2: 2.0,
        cDt: 0.0, cAt: 0.002, cDe: 2.5, cSu: 0.0, cRe: 2.5, cCurv: -4,
        m1At: 0.001, m1De: 1.2, m1Su: 0.0, m1Re: 1.2, m1Curv: -6,
        i_m2At: 0.001, i_m2De: 0.6, i_m2Su: 0.0, i_m2Re: 0.6, i_m2Curv: -8,
        fVib: 0, aVib: 0, tVib: 0
    ),

    // 2. Bajo FM Punzante (Solid FM Bass estilo Yamaha DX100 / TX81Z LatelyBass)
    fmBass: (
        name: "Solid FM Bass",
        c: 1, m1: 1, i_m2: 2,
        i1: 3.2, i_i2: 1.8,
        cDt: 0.0, cAt: 0.005, cDe: 0.6, cSu: 0.1, cRe: 0.3, cCurv: -3,
        m1At: 0.005, m1De: 0.4, m1Su: 0.05, m1Re: 0.2, m1Curv: -4,
        i_m2At: 0.002, i_m2De: 0.2, i_m2Su: 0.0, i_m2Re: 0.1, i_m2Curv: -5,
        fVib: 0, aVib: 0, tVib: 0
    ),

    // 3. Piano Eléctrico FM (DX7 E.Piano clásico)
    fmElectricPiano: (
        name: "FM Electric Piano",
        c: 1, m1: 1, i_m2: 14,
        i1: 2.0, i_i2: 0.8,
        cDt: 0.0, cAt: 0.005, cDe: 1.8, cSu: 0.2, cRe: 1.0, cCurv: -3,
        m1At: 0.002, m1De: 0.8, m1Su: 0.1, m1Re: 0.8, m1Curv: -4,
        i_m2At: 0.001, i_m2De: 0.15, i_m2Su: 0.0, i_m2Re: 0.15, i_m2Curv: -6,
        fVib: 4.5, aVib: 0.5, tVib: 1.0
    ),

    // 4. Pad Microtonal Atmosférico / Shimmer Drone
    fmAtmospherePad: (
        name: "Microtonal Drone Pad",
        c: 1, m1: 2.01, i_m2: 0.5,
        i1: 1.2, i_i2: 1.5,
        cDt: 0.05, cAt: 0.8, cDe: 1.5, cSu: 0.7, cRe: 2.5, cCurv: -2,
        m1At: 1.2, m1De: 1.0, m1Su: 0.5, m1Re: 2.0, m1Curv: -2,
        i_m2At: 0.8, i_m2De: 1.2, i_m2Su: 0.4, i_m2Re: 2.0, i_m2Curv: -2,
        fVib: 5.0, aVib: 1.5, tVib: 0.8
    ),

    // 5. FM Lead Agresivo / Sync Style
    fmHardLead: (
        name: "FM Industrial Lead",
        c: 1, m1: 3, i_m2: 5,
        i1: 5.0, i_i2: 3.5,
        cDt: 0.0, cAt: 0.01, cDe: 0.4, cSu: 0.6, cRe: 0.4, cCurv: -2,
        m1At: 0.01, m1De: 0.3, m1Su: 0.4, m1Re: 0.3, m1Curv: -3,
        i_m2At: 0.005, i_m2De: 0.2, i_m2Su: 0.2, i_m2Re: 0.2, i_m2Curv: -4,
        fVib: 6.0, aVib: 2.0, tVib: 0.3
    )
);
