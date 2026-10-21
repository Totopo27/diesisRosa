// Carro Rosa Xen
// Presenta:
// SINTETIZADOR MICROTONAL

// Control del servidor
s.boot;
s.quit;
s.meter;
s.options.hardwareBufferSize = 128; // 128 baja latencia (default de MacOS: 512)
s.options.numInputBusChannels = 0; // Inhabilita entradas

OSCFunc.trace(true);
OSCFunc.trace(false);

// Variables ambientales obligatorias
(
// Arrays para crear sintes polifónicos
~s1OSC = Array.newClear(384); // OSC
~s1ch1 = Array.newClear(128); // Canal MIDI 1
~s1ch2 = Array.newClear(128); // Canal MIDI 2
~s1ch3 = Array.newClear(128); // Canal MIDI 3

// Grupos (control de parámetros en grupo)
~groupOSC = Group.new;
~groupch1 = Group.new;
~groupch2 = Group.new;
~groupch3 = Group.new;

// "Yo mismo" (me envío datos OSC a mí mismo)
~yoMismo = NetAddr.new("127.0.0.1", 57120);
)

// Temperamento Igual de 31 divisiones (31-TET)
(
// 1. Parámetros editables por el usuario para establecer la referencia
var refFreq = 440.0; // Frecuencia de referencia en Hz (editable)
var refOSC = 124;    // Nota de referencia (A4 = 124)
var total = 384;     // Tamaño total del array (tres canales MIDI estándar de 0 a 127)

// 2. Cálculo del ratio por paso
var stepRatio = 2.pow(1/31); // Raíz 31 de 2

// 3. Creación del array de 384 frecuencias
~tet31 = Array.fill(total, { |i|
    var distance = i - refOSC; // Calcula la distancia en pasos de 31-TET desde el ancla (A4)
    (refFreq * (stepRatio.pow(distance))); // Fórmula: f = f_ref * (2^(1/31))^distancia
});

// 4. Verificaciones en el Post Window
"--- Temperamento Igual de 31 tonos (31-TET) ---".postln;
"Frecuencia de la nota de referencia (OSC %): % Hz".format(refOSC, ~tet31.at(refOSC)).postln;
"Frecuencia nota 101 (Do central / C4): % Hz".format(~tet31.at(101)).postln;
"Frecuencia base nota 0 (A0): % Hz".format(~tet31.at(0)).postln;
)

// Temperamento Igual de 41 divisiones (41-TET)
(
// 1. Parámetros editables por el usuario para establecer la referencia
var refFreq = 440.0; // Frecuencia de referencia en Hz (editable)
var refOSC = 164;    // Nota de referencia (A4 = 164)
var total = 384;     // Tamaño total del array (tres canales MIDI estándar de 0 a 127)

// 2. Cálculo del ratio por paso
var stepRatio = 2.pow(1/41); // Raíz 41 de 2

// 3. Creación del array de 384 frecuencias
~tet41 = Array.fill(total, { |i|
    var distance = i - refOSC; // Calcula la distancia en pasos de 41-TET desde el ancla (A4)
    (refFreq * (stepRatio.pow(distance))); // Fórmula: f = f_ref * (2^(1/41))^distancia
});

// 4. Verificaciones en el Post Window
"--- Temperamento Igual de 41 tonos (41-TET) ---".postln;
"Frecuencia de la nota de referencia (OSC %): % Hz".format(refOSC, ~tet41.at(refOSC)).postln;
"Frecuencia nota 133 (Do central / C4): % Hz".format(~tet41.at(133)).postln;
"Frecuencia base nota 0 (A0): % Hz".format(~tet41.at(0)).postln;
)

// Temperamento Igual de 53 divisiones (53-TET)
(
// 1. Parámetros editables por el usuario para establecer la referencia
var refFreq = 440.0; // Frecuencia de referencia en Hz (editable)
var refOSC = 212;    // Nota de referencia (A4 = 212)
var total = 384;     // Tamaño total del array (tres canales MIDI estándar de 0 a 127)

// 2. Cálculo del ratio por paso
var stepRatio = 2.pow(1/53); // Raíz 53 de 2

// 3. Creación del array de 384 frecuencias
~tet53 = Array.fill(total, { |i|
    var distance = i - refOSC; // Calcula la distancia en pasos de 53-TET desde el ancla (A4)
    (refFreq * (stepRatio.pow(distance))); // Fórmula: f = f_ref * (2^(1/53))^distancia
});

// 4. Verificaciones en el Post Window
"--- Temperamento Igual de 53 tonos (53-TET) ---".postln;
"Frecuencia de la nota de referencia (OSC %): % Hz".format(refOSC, ~tet53.at(refOSC)).postln;
"Frecuencia nota 172 (Do central / C4): % Hz".format(~tet53.at(172)).postln;
"Frecuencia base nota 0 (A0): % Hz".format(~tet53.at(0)).postln;
)

// Temperamento Igual de 12 divisiones (12-TET)
(
// 1. Parámetros editables por el usuario para establecer la referencia
var refFreq = 440.0; // Frecuencia de referencia en Hz (editable)
var refMidi = 69;    // Nota MIDI de referencia (A4 = 69)
var total = 128;     // Tamaño total del array (rango MIDI estándar de 0 a 127)

// 2. Cálculo del ratio por paso (semitono temperado)
var stepRatio = 2.pow(1/12); // Raíz duodécima de 2

// 3. Creación del array de 128 frecuencias
~tet12 = Array.fill(total, { |i|
    var distance = i - refMidi; // Calcula la distancia en semitonos desde el ancla (A4)
    (refFreq * (stepRatio.pow(distance))); // Fórmula: f = f_ref * (2^(1/12))^distancia
});

// 4. Verificaciones en el Post Window
"--- Temperamento Igual de 12 tonos (12-TET) ---".postln;
"Frecuencia de la nota de referencia (nota %): % Hz".format(refMidi, ~tet12.at(refMidi)).postln;
"Frecuencia nota 60 (C4): % Hz".format(~tet12.at(60)).postln;
"Frecuencia nota 0 (C-1): % Hz".format(~tet12.at(0)).postln;
)

// Afinación pitagórica acomodada en 53edo
// Teclado 53 EDO, GEN 22, 7/12: {[4/7, 3/5]}, invertido, Base Root 172.
(
// 1. Array vacío para los 53 ratios base
~pitag = Array.newClear(53);

// 2. Establecemos el grado 40 (nota La) como punto de partida (ratio 1.0 temporal)
~pitag.put(40, 1.0);

// 3. Secuencia Directa: 26 quintas ascendentes desde el 40 (hasta el grado 51)
(1..26).do { |k|
    var prevPc = (40 + ((k - 1) * 31)) % 53;
    var currentPc = (40 + (k * 31)) % 53;
    var ratio = ~pitag.at(prevPc) * (3/2);

    // Ajuste para mantener el ratio siempre dentro de la octava [1, 2)
    while { ratio >= 2.0 } { ratio = ratio / 2.0 };
    ~pitag.put(currentPc, ratio);
};

// 4. Secuencia Inversa: 26 cuartas ascendentes (quintas descendentes) desde el 40 (hasta el 29)
(1..26).do { |k|
    var prevPc = (40 + ((k - 1) * 22)) % 53;
    var currentPc = (40 + (k * 22)) % 53;
    var ratio = ~pitag.at(prevPc) * (4/3); // 4/3 es la quinta inversa (cuarta)

    // Ajuste para mantener el ratio siempre dentro de la octava [1, 2)
    while { ratio >= 2.0 } { ratio = ratio / 2.0 };
    ~pitag.put(currentPc, ratio);
};

// 5. Normalización de octava
// Re-escalamos todo para que el PC 0 sea verdaderamente la base 1.0
~offset = ~pitag.at(0);
53.do { |i|
    var newRatio = ~pitag.at(i) / ~offset;
    if(newRatio < 1.0) { newRatio = newRatio * 2.0 };
    ~pitag.put(i, newRatio);
};

// 6. Construcción del array desplegado de 384 frecuencias
// f0 ajustado considerando que PC 40 (índice 212) caerá en la Octava 4
~f0 = 440 / (~pitag.at(40) * (2 ** 4));

~pitag53 = Array.fill(384, { |i|
    var virtualIndex = i + 40;
    var pc = virtualIndex % 53;
    var octave = virtualIndex div: 53;

    ~f0 * ~pitag.at(pc) * (2 ** octave);
});
)

// Mesotónico 1/4 de comma acomodado en 31edo
// Teclado 31 EDO, GEN 18, 7/12: {[4/7, 3/5]}, invertido, Base Root 101.
(
// 1. Array vacío para los 31 ratios base
~mean31 = Array.newClear(31);

// 2. Definición de la quinta mesotónica (Aron 1/4cs)
~qMeantone = (3/2) / ((81/80).pow(1/4));

// Establecemos el grado 23 como punto de partida (ratio 1.0 temporal)
~mean31.put(23, 1.0);

// 3. Secuencia Directa: 15 quintas mesotónicas ascendentes desde el 23 (hasta el grado 14)
(1..15).do { |k|
    var prevPc = (23 + ((k - 1) * 18)) % 31;
    var currentPc = (23 + (k * 18)) % 31;
    var ratio = ~mean31.at(prevPc) * ~qMeantone;

    // Ajuste para mantener el ratio siempre dentro de la octava [1, 2)
    while { ratio >= 2.0 } { ratio = ratio / 2.0 };
    ~mean31.put(currentPc, ratio);
};

// 4. Secuencia Inversa: 15 cuartas mesotónicas ascendentes (quintas descendentes) desde el 23 (hasta el 1)
// Nota: en 31-EDO la cuarta o quinta inversa equivale a dar saltos del generador 13
(1..15).do { |k|
    var prevPc = (23 + ((k - 1) * 13)) % 31;
    var currentPc = (23 + (k * 13)) % 31;
    var ratio = ~mean31.at(prevPc) * (2.0 / ~qMeantone); // 2.0 / qMeantone es la cuarta mesotónica

    // Ajuste para mantener el ratio siempre dentro de la octava [1, 2)
    while { ratio >= 2.0 } { ratio = ratio / 2.0 };
    ~mean31.put(currentPc, ratio);
};

// 5. Normalización de octava
// Re-escalamos todo para que el PC 0 sea verdaderamente la base 1.0
~offset = ~mean31.at(0);
31.do { |i|
    var newRatio = ~mean31.at(i) / ~offset;
    if(newRatio < 1.0) { newRatio = newRatio * 2.0 };
    ~mean31.put(i, newRatio);
};

// 6. Construcción del array desplegado de 384 frecuencias
// Lógica de mapeo para 31 tonos (offset = 23)
~f0 = 440 / (~mean31.at(23) * (2 ** 4));

~meantone31 = Array.fill(384, { |i|
    var virtualIndex = i + 23;
    var pc = virtualIndex % 31;
    var octave = virtualIndex div: 31;

    ~f0 * ~mean31.at(pc) * (2 ** octave);
});
)

//Temperamento Mágico acomodado en 41edo
(
// 1. Definición de parámetros del Temperamento Mágico
var total = 384;      // Tamaño solicitado
var notesPerOct = 41; // Notas por "octava"
var genSteps = 13;    // El generador es la nota 13
var generator = 3.pow(1/5); // Ratio del generador (tercera mayor mágica)

// 2. Cálculo del ratio por paso (step)
// Si 13 pasos = generator, entonces 1 paso = generator ^ (1/13)
var stepRatio = generator.pow(1/genSteps); // Equivale a 3.pow(1/65)

// 3. Creación del array de 384 frecuencias
// El índice 164 (inicio de octava 4) es el ancla de 440 Hz
~magic41 = Array.fill(total, { |i|
    var distance = i - 164;
    (440 * (stepRatio.pow(distance)));
});

// 4. Verificaciones en el Post Window
"--- Temperamento Mágico (41 notas) ---".postln;
"Frecuencia índice 164 (PC 31, Oct 4): % Hz".format(~magic41.at(164)).postln;
"Frecuencia índice 164-31 (Nota 0, Oct 4): % Hz".format(~magic41.at(164-31)).postln;

// Comprobación de los generadores:
"Relación Nota 13 -> Nota 0 (Oct 4): % (Esperado: %)".format(
	(~magic41.at(164 - 31 + 13) / ~magic41.at(164 - 31)),
    generator
).postln;

// Comprobación de la pseudoctava (no es 2.0)
"Ratio de pseudoctava (41 pasos): %".format(stepRatio.pow(41)).postln;
)

// Harry Partch 43 tonos, Justa Entonación
(
// 1. Definimos los ratios del sistema de 43 tonos de Partch
var ratios = [
    1/1, 81/80, 33/32, 21/20, 16/15, 12/11, 11/10, 10/9, 9/8, 8/7,
    7/6, 32/27, 6/5, 11/9, 5/4, 14/11, 9/7, 21/16, 4/3, 27/20,
    11/8, 7/5, 10/7, 16/11, 40/27, 3/2, 32/21, 14/9, 11/7, 8/5,
    18/11, 5/3, 27/16, 12/7, 7/4, 16/9, 9/5, 20/11, 11/6, 15/8,
    40/21, 64/33, 160/81
];

var f0 = 24.5;    // Frecuencia base (Sol 0)
var total = 384;   // Definimos el tamaño total solicitado

// 2. Creamos el array rellenando con la fórmula de octavas
~partch = Array.fill(total, { |i|
    var ratioIndex = i % 43;   // índice de ratio (0–42)
    var octave = i div: 43;    // división entera para la octava
    (f0 * ratios[ratioIndex] * (2 ** octave));
});

// 3. Verificación en el Post Window
"Array ~partch creado con % elementos".format(~partch.size).postln;
"Índice 0 (G0): % Hz".format(~partch.at(0)).postln;
"Índice 172 (G4): % Hz".format(~partch.at(172)).postln;
"Índice 180 (A+4): % Hz".format(~partch.at(172+8)).postln;
)

// D'Alessandro de Erv Wilson
(
// 1. Frecuencias base para la octava central (Do 4 = 256 Hz)
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

var total = 384;

// 2. Generación del array con desplazamiento de octava correcto
~dalessandro = Array.fill(total, { |i|
    var grado = i % 42;
    var octave = i div: 42;
    // Multiplicamos por 2^(octave-4) para que la octava 4 sea el factor 1
    (freqOct4[grado] * (2 ** (octave - 4)));
});

// 3. Mensajes de confirmación
"Array ~dalessandro creado con % elementos".format(~dalessandro.size).postln;
"Índice 0 (∅0): % Hz".format(~dalessandro.at(0)).postln;
"Índice 168 (∅4): % Hz".format(~dalessandro.at(168)).postln;
"Índice 170 (C4): % Hz".format(~dalessandro.at(168+2)).postln;
"Índice 201 (A4): % Hz".format(~dalessandro.at(168+33)).postln;
)

// Centaur de Kraig Grady (12 tonos, justa entonación límite 7)
(
// 1. Ratios del sistema Centaur
var ratiosCentaur = [ 1/1, 21/20, 9/8, 7/6, 5/4, 4/3, 7/5, 3/2, 14/9, 5/3, 7/4, 15/8 ];

// 2. Parámetros editables por el usuario para establecer la referencia
var refFreq = 440; // Frecuencia de referencia en Hz (puedes editar este valor)
var refMidi = 69;  // Nota MIDI de referencia (A4 = 69)
var total = 384;   // Tamaño total del array usado en tu sintetizador

// 3. Cálculos internos para la afinación
var refDegree = refMidi % 12;    // En Centaur, A4 (MIDI 69) cae en el grado 9
var refOctave = refMidi div: 12; // Octava 5 en términos de índices MIDI
var f0; // Variable para almacenar la frecuencia de la nota MIDI 0 (C-1)

// Calculamos f0 dividiendo la frecuencia de referencia entre el ratio del grado
// y dividiendo por las octavas correspondientes hacia abajo
f0 = refFreq / ratiosCentaur[refDegree] / (2 ** refOctave);

// 4. Generación del array de 384 frecuencias
~centaur = Array.fill(total, { |i|
    var ratioIndex = i % 12;
    var octave = i div: 12;
    (f0 * ratiosCentaur[ratioIndex] * (2 ** octave));
});

// 5. Verificaciones en el Post Window
"--- Sistema Centaur (Kraig Grady) ---".postln;
"Frecuencia nota % (Grado %): % Hz".format(refMidi, refDegree, ~centaur.at(refMidi)).postln;
"Frecuencia nota 21 (A0): % Hz".format(~centaur.at(21)).postln;
"Frecuencia nota 0 (C-1): % Hz".format(~centaur.at(0)).postln;
)

// Sintetizador FM
(
SynthDef.new(\fm,
{
	arg // Parámetros modulables
	i_out = 0, i_vol = 1, volMaster = 0.2, i_amp = 1, gate = 0,
	f = 220, det = 1,

	// Ratios de frecuencia
	c = 1, m1 = 1, i_m2 = 1,

	// Índices de modulación
	i1 = 0,  // Índice de M1 sobre Carrier
	i_i2 = 0,  // Índice de M2 sobre M1

	// Vibrato
	fVib = 5, aVib = 0, tVib = 0,

	// Envolvente M2 (modula a M1)
	i_m2At = 0, i_m2De = 0, i_m2Su = 1, i_m2Re = 0, i_m2Curv = 0, i_m2Offset = 0,

	// Envolvente M1 (modula al carrier)
	m1At = 0, m1De = 0, m1Su = 1, m1Re = 0, m1Curv = 0, m1Offset = 0,

	// Envolvente Carrier
	cDt = 0, cAt = 0.01, cDe = 0.3, cSu = 0.5, cRe = 1, cCurv = -2;

	var m2Env, m1Env, cEnv, vib, cFrec, m1Ratio, m2Ratio, m1Amp, m2Amp, m1Frec, m2Sig, sig;

	// Envolvente del modulador 2 (más profundo en la cadena)
	m2Env = EnvGen.kr(
		Env.adsr(
			attackTime: i_m2At,
			decayTime: i_m2De,
			sustainLevel: i_m2Su,
			releaseTime: i_m2Re,
			curve: i_m2Curv,
			bias: i_m2Offset
		)
	);

	// Envolvente del modulador 1
	m1Env = EnvGen.kr(
		Env.adsr(
			attackTime: m1At,
			decayTime: m1De,
			sustainLevel: m1Su,
			releaseTime: m1Re,
			peakLevel: 1,
			curve: m1Curv,
			bias: m1Offset
		)
	);

	// Envolvente del carrier
	cEnv = EnvGen.kr(
		Env.dadsr(
			delayTime: cDt,
			attackTime: cAt,
			decayTime: cDe,
			sustainLevel: cSu,
			releaseTime: cRe,
			curve: cCurv
		),
		gate,
		doneAction: 2
	);

	// Vibrato
	vib = LFTri.kr(
		freq: fVib,
		mul: Line.kr(start: 0, end: aVib, dur: tVib)
	);

	// Frecuencia del carrier con vibrato
	cFrec = f + (vib * det);

	// Cálculo de ratios y amplitudes
	m1Ratio = m1 / c;
	m2Ratio = i_m2 / c;

	// Amplitudes de modulación (basadas en índice)
	m1Amp = f * i1;
	m2Amp = (cFrec * m1Ratio) * i_i2; // Amplitud de M2 relativa a frecuencia de M1

	// Modulador 2 modula al Modulador 1
	m1Frec = cFrec * m1Ratio;
	m2Sig = SinOsc.ar(
		freq: m1Frec * m2Ratio
	) * m2Amp * m2Env;

	// Modulador 1 (modulado por M2) modula al Carrier
	sig = SinOsc.ar(
		freq: cFrec + (
			SinOsc.ar(
				freq: m1Frec + m2Sig  // M1 es modulado por M2
			) * m1Amp * m1Env
		)
	) * cEnv;

	sig = sig * i_amp * i_vol * volMaster;
	Out.ar(i_out, sig ! 2);
}).add;
)

// Oscillator sync (prototipo)
(

SynthDef.new(\sync,
{
arg // Parámetros modulables
i_out = 0, i_vol = 1, volMaster = 0.2, i_amp = 1, gate = 0,
f = 220, det = 1,
// Ratios para el sync
c = 1, slaveRatio = 2, sweepAmt = 1000,
// Vibrato
fVib = 5, aVib = 0, tVib = 0,
// Envolvente de barrido (sweep) para el oscilador esclavo
swAt = 0.01, swDe = 0.5, swSu = 0, swRe = 1, swCurv = -4,
// Envolvente Carrier (amplitud general)
cDt = 0, cAt = 0.01, cDe = 0.3, cSu = 0.5, cRe = 1, cCurv = -2;

var sweepEnv, cEnv, vib, masterFreq, slaveFreq, sig;

// Envolvente de barrido del esclavo (esto crea el sonido clásico de sync)
sweepEnv = EnvGen.kr(
	Env.adsr(
		attackTime: swAt,
		decayTime: swDe,
		sustainLevel: swSu,
		releaseTime: swRe,
		curve: swCurv
	),
	gate
);

// Envolvente de amplitud
cEnv = EnvGen.kr(
	Env.dadsr(
		delayTime: cDt,
		attackTime: cAt,
		decayTime: cDe,
		sustainLevel: cSu,
		releaseTime: cRe,
		curve: cCurv
	),
	gate,
	doneAction: 2
);

// Vibrato aplicado a la frecuencia fundamental (el master)
vib = LFTri.kr(
	freq: fVib,
	mul: Line.kr(start: 0, end: aVib, dur: tVib)
);

masterFreq = (f + (vib * det)) * c;
// El esclavo comienza en una frecuencia base y la envolvente la desplaza
slaveFreq = (masterFreq * slaveRatio) + (sweepEnv * sweepAmt);

// Oscilador con Hard Sync (SyncSaw). masterFreq hace el reinicio, slaveFreq es el esclavo.
sig = SyncSaw.ar(syncFreq: masterFreq, sawFreq: slaveFreq) * cEnv;

sig = sig * i_amp * i_vol * volMaster;
Out.ar(i_out, sig ! 2);

}).add;

)

// Parámetros editables del sintetizador FM a tiempo real
(
~temp = ~dalessandro; // ~tet12, ~tet31, ~tet41, ~tet53, ~partch, ~dalessandro, ~meantone31, ~magic41, ~pitag53, ~centaur
~vol = 1;
~volMaster = 0.2;
~amp = 1;
~det = 1;
~c = 1;
~m1 = 2;
~i1 = 5;
~fVib = 0;
~aVib = 0;
~tVib = 0;
~cDt = 0;
~cAt = 0.1;
~cDe = 1.5;
~cSu = 0.1;
~cRe = 1.5;
~cCurv = -4;
)

// OSC
(
// Botones de transposición
OSCdef.new(
	\transp,
	{
		arg msg;
		msg.postln;
		~octave = 2.pow(msg[1]); // 2.pow(0.0) = 1.0 (sin transposición)
	},
	'/param/a/octave', nil, 57120
);

// Notas
OSCdef.new(\notaOSC, {
	arg msg;
	var nn = msg[1], onoff = msg[2];
	msg.postln;
	if( onoff > 0, // Si recibe 127:
		{
			~s1OSC[nn] = Synth(\fm,
				[
					\vol, ~vol,
					\volMaster, ~volMaster,
					\amp, ~amp,
					\gate, 1,
					\f, ~temp[nn] * ~octave,
					\det, ~det,
					\c, ~c,
					\m1, ~m1,
					\i1, ~i1,
					\fVib, ~fVib,
					\aVib, ~aVib,
					\tVib, ~tVib,
					\cDt, ~cDt,
					\cAt, ~cAt,
					\cDe, ~cDe,
					\cSu, ~cSu,
					\cRe, ~cRe,
					\cCurv, ~cCurv

				],
				target: ~groupOSC
			);
			~groupOSC.set(\volMaster, ~volMaster);
		}, // Termina el true

		{
   ~s1OSC[nn].set(\gate, 0); // Indica a la envolvente que debe cerrar
   ~s1OSC[nn] = nil;         // Limpia la referencia en el array
}
	); // Termina el if
}, '/mnote', nil /*IP address*/, 57120
);

OSCdef.new(\panic_soft, {
    ~groupOSC.set(\gate, 0); // Envía gate 0 a todo el grupo de voces
    ~s1OSC.fill(nil);      // Limpia las referencias en tu array para evitar errores
    "Pánico suave: Notas liberadas".postln;
}, '/allnotesoff');

OSCdef.new(\panic_hard, {
    ~groupOSC.freeAll;   // Mata todos los sintes en el grupo al instante
    ~s1OSC.fill(nil);  // Reinicia el array de voces

    "Pánico duro: Grupo de voces eliminado".postln;
}, '/allsoundoff');

~yoMismo.sendMsg("/param/a/octave", 0);
)

// MIDI
(
// Habilitación
MIDIClient.init(verbose: true);
MIDIIn.connectAll;

// Canal MIDI 1
MIDIdef.noteOn(\noteOnCh1, {
	arg vel, nn, ch;
	[vel, nn, ch].postln;
	if (ch == 0, {
		~s1ch1[nn] = Synth(\fm,
			[
				\vol, ~vol,
				\volMaster, ~volMaster,
				\amp, ~amp,
				\gate, 1,
				\f, ~temp[nn],
				\det, ~det,
				\c, ~c,
				\m1, ~m1,
				\i1, ~i1,
				\fVib, ~fVib,
				\aVib, ~aVib,
				\tVib, ~tVib,
				\cDt, ~cDt,
				\cAt, ~cAt,
				\cDe, ~cDe,
				\cSu, ~cSu,
				\cRe, ~cRe,
				\cCurv, ~cCurv

			],
			target: ~groupch1
		);

		~groupch1.set(\volMaster, ~volMaster);
	});
});

MIDIdef.noteOff(\noteOffCh1, {
	arg vel, nn, ch;
	[vel, nn, ch].postln;
	if(ch == 0) {
		~s1ch1[nn].set(\gate, 0);
		~s1ch1[nn] = nil;
	};
});

// Canal MIDI 2
MIDIdef.noteOn(\noteOnCh2, {
	arg vel, nn, ch;
	[vel, nn, ch].postln;
	if (ch == 1, {
		~s1ch2[nn] = Synth(\fm,
			[
				\vol, ~vol,
				\volMaster, ~volMaster,
				\amp, ~amp,
				\gate, 1,
				\f, ~temp[(nn + 128)],
				\det, ~det,
				\c, ~c,
				\m1, ~m1,
				\i1, ~i1,
				\fVib, ~fVib,
				\aVib, ~aVib,
				\tVib, ~tVib,
				\cDt, ~cDt,
				\cAt, ~cAt,
				\cDe, ~cDe,
				\cSu, ~cSu,
				\cRe, ~cRe,
				\cCurv, ~cCurv

			],
			target: ~groupch2
		);

		~groupch2.set(\volMaster, ~volMaster);
	});
});

MIDIdef.noteOff(\noteOffCh2, {
	arg vel, nn, ch;
	[vel, nn, ch].postln;
	if(ch == 1) {
		~s1ch2[nn].set(\gate, 0);
		~s1ch2[nn] = nil;
	};
});

// Canal MIDI 3
MIDIdef.noteOn(\noteOnCh3, {
	arg vel, nn, ch;
	[vel, nn, ch].postln;
	if (ch == 2, {
		~s1ch3[nn] = Synth(\fm,
			[
				\vol, ~vol,
				\volMaster, ~volMaster,
				\amp, ~amp,
				\gate, 1,
				\f, ~temp[(nn + 256)],
				\det, ~det,
				\c, ~c,
				\m1, ~m1,
				\i1, ~i1,
				\fVib, ~fVib,
				\aVib, ~aVib,
				\tVib, ~tVib,
				\cDt, ~cDt,
				\cAt, ~cAt,
				\cDe, ~cDe,
				\cSu, ~cSu,
				\cRe, ~cRe,
				\cCurv, ~cCurv

			],
			target: ~groupch3
		);

		~groupch3.set(\volMaster, ~volMaster);
	});
});

MIDIdef.noteOff(\noteOffCh3, {
	arg vel, nn, ch;
	[vel, nn, ch].postln;
	if(ch == 2) {
		~s1ch3[nn].set(\gate, 0);
		~s1ch3[nn] = nil;
	};
});

// Botones de pánico vía MIDI (Control Change)
MIDIdef.cc(\panic_midi, { arg val, num, chan;
    case
    { num == 123 } { // All Notes Off: Pánico suave
        [~groupch1, ~groupch2, ~groupch3, ~groupOSC].do(_.set(\gate, 0));
        [~s1ch1, ~s1ch2, ~s1ch3, ~s1OSC].do(_.fill(nil));
        "Pánico MIDI suave: Notas liberadas (release)".postln;
    }
    { num == 120 } { // All Sound Off: Pánico fuerte
        [~groupch1, ~groupch2, ~groupch3, ~groupOSC].do(_.freeAll);
        [~s1ch1, ~s1ch2, ~s1ch3, ~s1OSC].do(_.fill(nil));
        "Pánico MIDI fuerte: Sonido cortado instantáneamente".postln;
    };
});
)

// Activar Pánico Suave OSC
~yoMismo.sendMsg("/allnotesoff");

// Activar Pánico Fuerte OSC
~yoMismo.sendMsg("/allsoundoff");

// Activar Pánico Suave MIDI (All Notes Off - CC 123)
MIDIIn.doControlAction(src: 0, chan: 0, num: 123, val: 1);

// Activar Pánico Fuerte MIDI (All Sound Off - CC 120)
MIDIIn.doControlAction(src: 0, chan: 0, num: 120, val: 1);

// Pruebas notas MIDI

MIDIIn.doNoteOnAction(1, 1, 60, 100);

MIDIIn.doNoteOffAction(1, 1, 40, 100);


MIDIOut.doNoteOnAction(1, 0, 60, 0);

MIDIOut.doNoteOffAction(1, 0, 60, 0);

// Pruebas notas OSC

~yoMismo.sendMsg("/param/a/octave", 0);
~yoMismo.sendMsg("/param/a/octave", 1);
~yoMismo.sendMsg("/param/a/octave", 2);
~yoMismo.sendMsg("/param/a/octave", 3);
~yoMismo.sendMsg("/param/a/octave", -1);
~yoMismo.sendMsg("/param/a/octave", -2);
~yoMismo.sendMsg("/param/a/octave", -3);

// Escala pentatonica en D'Alessandro
~yoMismo.sendMsg("/mnote", 168+2, 127.0);
~yoMismo.sendMsg("/mnote", 168+9, 127.0);
~yoMismo.sendMsg("/mnote", 168+16, 127.0);
~yoMismo.sendMsg("/mnote", 168+27, 127.0);
~yoMismo.sendMsg("/mnote", 168+33, 127.0);

~yoMismo.sendMsg("/allnotesoff");

~yoMismo.sendMsg("/allsoundoff");

// Quinta del lobo en mesotónico 1/4 de comma (PC14-PC1)
~meantone31.at(101+31+1) / ~meantone31.at(101+14) ;
// Tercera del lobo (grande) en mesotónico 1/4 de comma
~meantone31.at(101+14+10) / ~meantone31.at(101+14) ;

// Quinta del lobo en pitagórico: PC 29 (Octava 5) / PC 51 (Octava 4)
~pitag53.at(254) / ~pitag53.at(223);

// Comprobación del ratio de la tritava en el temperamento mágico
~magic41.at(0+41+41+41+41+41+24)/~magic41.at(0+41+41+41+41);

// Afinador
x = { SinOsc.ar(440, 0, 0.2!2) }.play;
x.free;