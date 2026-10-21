# AUDITORÍA DE ARQUITECTURA Y CÓDIGO: SCMicroSynth (v1.0 → v2.0 Modular)
**Autor:** Auditoría Técnica & Arquitectura de Software  
**Fecha:** Octubre 2026  
**Objetivo:** Diagnóstico exhaustivo del script monolítico `origen/Sintetizador microtonal 18.scd` y especificación del sistema modular con banco de presets FM.

---

## 1. Resumen Ejecutivo

El código original (`Sintetizador microtonal 18.scd`) es una pieza de investigación acústica y microtonal con implementaciones matemáticas precisas (31-TET, 41-TET, 53-TET, 12-TET, Afinación Pitagórica en 53edo, Mesotónico de 1/4 comma en 31edo, Temperamento Mágico en 41edo, Partch 43 tonos, D'Alessandro de Erv Wilson y Centaur de Kraig Grady). Además, implementa un motor de síntesis FM de 2 moduladores en cascada y un prototipo de Hard Sync (`SyncSaw`).

Sin embargo, a nivel de **ingeniería de software y arquitectura en SuperCollider**, el código adolece de problemas críticos de mantenibilidad, acoplamiento y gestión de recursos que impiden su escalabilidad y estabilidad en vivo.

---

## 2. Hallazgos del Audit (Severidad y Categorización)

### 🔴 CRÍTICO / ALTO (Riesgos de ejecución, concurrencia y fugas)

1. **Condición de carrera en arranque (`s.boot` sin sincronización / server sync):**
   - *Ubicación:* Líneas 6–10 y líneas 24–27.
   - *Problema:* Se crean `Group.new` y `SynthDef.new.add` inmediatamente en el espacio de trabajo. Si el servidor (`scsynth`) aún no terminó de bootear, los Node IDs fallan silenciosamente (`FAILURE IN SERVER /g_new Group not found`), dejando los grupos nulos o inválidos.
   - *Solución:* Usar bloques `s.waitForBoot { ... }` o `ServerTree` / `ServerQuit` hooks.

2. **Fuga de Nodos / Voces colgadas ante NoteOff desordenado:**
   - *Ubicación:* Líneas 576–606 (OSC) y 638–759 (MIDI).
   - *Problema:* El seguimiento polifónico se hace con arrays de tamaño fijo (`~s1OSC[nn]`, `~s1ch1[nn]`). Si un mensaje de NoteOn se repite para la misma nota antes de recibir NoteOff (legato, retrigger rápido o jitter de red), el puntero al Synth anterior se sobreescribe en el array con el nuevo Synth. Al llegar el NoteOff posterior, solo libera el segundo, dejando el primero sonando indefinidamente en el servidor (Voice leak).
   - *Solución:* Monitorear siempre el nodo activo antes de instanciar uno nuevo: `if(~voices[key].notNil) { ~voices[key].set(\gate, 0) };` o usar estructuras con ID de nodo/registro.

3. **Inconsistencia de volumen y amplificación:**
   - *Ubicación:* Líneas 465–466 y 600.
   - *Problema:* `sig = sig * i_amp * i_vol * volMaster;`. Luego en cada NoteOn se ejecuta `~groupch1.set(\volMaster, ~volMaster);`. Además de redundante (enviar un `/n_set` al grupo en cada evento de nota), mezclar 3 o más voces con `volMaster = 0.2` y sin limitador genera distorsión digital dura (clipping a +0 dBFS).
   - *Solución:* Encapsular el control de ganancia general en un bus de audio maestro o master fader (`ReplaceOut.ar` / `Limiter.ar`).

### 🟠 MEDIO (Acoplamiento y contaminación de estado)

4. **Polución masiva del entorno global (`currentEnvironment`):**
   - *Ubicación:* Variables `~temp`, `~tet31`, `~s1ch1`, `~groupOSC`, `~yoMismo`, etc.
   - *Problema:* Todas las estructuras habitan en el entorno raíz. Cualquier otro script o patch ejecutado en SuperCollider puede pisar estas variables.
   - *Solución:* Encapsular el estado en un diccionario de entorno autónomo (`IdentityDictionary` o `Event`), permitiendo múltiples instancias del sintetizador.

5. **Inyección manual y repetitiva de parámetros (Violación DRY):**
   - *Ubicación:* Bloques MIDI de Canal 1, Canal 2 y Canal 3 (líneas 638–759).
   - *Problema:* El array de argumentos de `Synth(\fm, [...])` se copia textualmente 4 veces a lo largo de 130 líneas. Si se añade un parámetro al SynthDef (por ejemplo, filtro o feedback), hay que modificar 4 sitios distintos manualmente.
   - *Solución:* Función despachadora de voces unificada (`playVoice(nn, vel, tuningOffset)`).

6. **Desfase de Ratios FM y división por cero potencial:**
   - *Ubicación:* Líneas 443–444 (`m1Ratio = m1 / c`).
   - *Problema:* Si en tiempo real el usuario setea `c = 0`, el servidor produce `NaN` o `inf`, enmudeciendo el sintetizador y emitiendo explosiones digitales.
   - *Solución:* Clamping o salvaguardas: `c.max(0.001)`.

### 🟡 BAJO / BUENAS PRÁCTICAS (Arquitectura de afinación y presets)

7. **Afinaciones dispersas y no parametrizables:**
   - Las afinaciones están calculadas mediante bloques de código sueltos que deben ser ejecutados a mano con `Ctrl+Enter`. No existe una interfaz unificada como `~tuningManager.getScale(\pitag53)`.
8. **Ausencia total de gestión de Presets:**
   - El sintetizador dependía de variables globales sueltas fijadas a mano (`~m1 = 2; ~i1 = 5;`). Si se quería cambiar de timbre a un bajo FM, campana o brass, había que reescribir variables en el editor.

---

## 3. Filosofía de Rediseño (Principios Matt Pocock / Deep Modules)

Siguiendo los principios de **módulos profundos** (*deep modules*):
- **Interfaz mínima y expresiva:** El usuario o el código principal solo interactúa con un número reducido de funciones: `synth.loadPreset(\bell)`, `synth.setTuning(\dalessandro)`, `synth.noteOn(...)`.
- **Implementación rica oculta:** Toda la complejidad matemática de los 10 temperamentos, la sincronización de nodos, la gestión de grupos y el parseo de archivos se oculta dentro de los módulos.
- **Costura limpia (Seam):** Cada componente reside en su propio archivo desacoplado y se comunica mediante contratos de datos bien definidos.

---

## 4. Estructura Modular Propuesta (v2.0)

```
SCMicroSynth/
├── main.scd                 # Punto de entrada orquestador (Boot, init y carga de módulos)
├── modules/
│   ├── engine.scd           # SynthDefs (\fm, \sync), Buses, Grupos y Master Limiter
│   ├── tunings.scd          # Catálogo completo de las 10 afinaciones microtonales
│   ├── presets.scd          # Banco de presets FM (Bells, Basses, Leads, Drones, E.Piano)
│   ├── voice_manager.scd    # Gestión polifónica sin fugas (Voice Allocation y Panic)
│   └── midi_osc.scd         # Controladores MIDIIn y OSCdef limpios
└── presets/                 # Presets persistentes (diccionarios estructurados)
    └── default_presets.scd
```
