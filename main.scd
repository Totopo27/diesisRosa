/*
    ===================================================================
    diesisRosa v2.0 - Sintetizador Microtonal Modular
    ===================================================================
    Punto de entrada principal.
    Carga todos los módulos bajo el principio de "Deep Modules" y
    sincroniza el arranque del servidor sin condiciones de carrera.

    Para ejecutar: Selecciona todo y pulsa Ctrl+Enter (o Cmd+Enter).
*/

(
s.waitForBoot({
    var baseDir = thisProcess.nowExecutingPath.dirname;

    "=================================================".postln;
    "  Iniciando diesisRosa v2.0 (Arquitectura Modular)...".postln;
    "=================================================".postln;

    // 1. Limpieza de entorno anterior si existiera
    if(~diesisRosa.notNil) {
        ~diesisRosa[\cleanup].value;
    };

    // 2. Carga de submódulos desacoplados
    ~diesisRosa = ();
    ~diesisRosa.dir = baseDir;

    // Módulo de Afinaciones
    ~diesisRosa.tuning = (baseDir +/+ "modules/tunings.scd").load;

    // Módulo de Presets FM
    ~diesisRosa.presets = (baseDir +/+ "modules/presets.scd").load;
    ~diesisRosa.presets.init(baseDir +/+ "presets/default_presets.scd");

    // Módulo de Audio Engine (SynthDefs, Buses, Master Stage)
    ~diesisRosa.engine = (baseDir +/+ "modules/engine.scd").load;
    ~diesisRosa.engine.init(s);

    // Módulo Gestor de Voces Polifónicas
    ~diesisRosa.voiceManager = (baseDir +/+ "modules/voice_manager.scd").load;
    ~diesisRosa.voiceManager.init(
        ~diesisRosa.engine,
        ~diesisRosa.tuning,
        ~diesisRosa.presets
    );

    // Módulo de Controladores (MIDI & OSC)
    ~diesisRosa.controller = (baseDir +/+ "modules/midi_osc.scd").load;
    ~diesisRosa.controller.init(~diesisRosa.voiceManager);

    // 3. API Pública Simplificada (Interfaz Mínima y Profunda)
    ~diesisRosa.setTuning = { |self, scaleKey|
        self.voiceManager.setScale(scaleKey);
    };

    ~diesisRosa.setPreset = { |self, presetKey|
        self.voiceManager.setPreset(presetKey);
    };

    ~diesisRosa.setMasterVolume = { |self, vol|
        self.engine.setMasterVolume(vol);
    };

    ~diesisRosa.panic = { |self|
        self.voiceManager.panicSoft;
    };

    ~diesisRosa.cleanup = { |self|
        self.controller.cleanup;
        self.engine.cleanup;
        "diesisRosa detenido y recursos liberados.".postln;
    };

    // 4. Configuración inicial por defecto
    ~diesisRosa.setTuning(\dalessandro);
    ~diesisRosa.setPreset(\fmBell);
    ~diesisRosa.setMasterVolume(0.25);

    "-------------------------------------------------".postln;
    "  ¡diesisRosa v2.0 listo para tocar!".postln;
    "  Afinaciones disponibles: ".post;
    ~diesisRosa.tuning.listScales.postln;
    "  Presets FM disponibles: ".post;
    ~diesisRosa.presets.listPresets.postln;
    "-------------------------------------------------".postln;
});
)

/*
    ===================================================================
    GUÍA RÁPIDA DE COMANDOS EN VIVO (Live-Coding & Pruebas):
    ===================================================================

    // Cambiar de preset FM:
    ~diesisRosa.setPreset(\fmBell);
    ~diesisRosa.setPreset(\fmBass);
    ~diesisRosa.setPreset(\fmElectricPiano);
    ~diesisRosa.setPreset(\fmAtmospherePad);
    ~diesisRosa.setPreset(\fmHardLead);

    // Cambiar afinación microtonal:
    ~diesisRosa.setTuning(\tet31);
    ~diesisRosa.setTuning(\tet41);
    ~diesisRosa.setTuning(\tet53);
    ~diesisRosa.setTuning(\partch);
    ~diesisRosa.setTuning(\dalessandro);
    ~diesisRosa.setTuning(\meantone31);
    ~diesisRosa.setTuning(\centaur);
    ~diesisRosa.setTuning(\magic41);
    ~diesisRosa.setTuning(\pitag53);

    // Probar notas directamente desde código (Nota, Velocidad, Canal):
    ~diesisRosa.voiceManager.noteOn(170, 100, 0); // Dispara Do4 en D'Alessandro
    ~diesisRosa.voiceManager.noteOff(170, 0);      // Apaga la nota

    // Pánico:
    ~diesisRosa.panic;

    // Liberar sintetizador al terminar la sesión:
    ~diesisRosa.cleanup;
*/
