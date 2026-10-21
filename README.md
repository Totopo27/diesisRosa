# diesisRosa v2.0 - Sintetizador Microtonal Modular en SuperCollider

Arquitectura modular para SuperCollider inspirada en principios de diseño de software (*Deep Modules*), desacoplada en submódulos funcionales y preparada para experimentación microtonal avanzada y síntesis FM.

---

## 🎹 Características Principales

- **10 Afinaciones y Temperamentos Microtonales:**
  - `tet31`, `tet41`, `tet53`: Temperamentos iguales de alta resolución.
  - `tet12`: Temperamento igual estándar.
  - `pitag53`: Afinación pitagórica encajada en 53-EDO (cálculo por quintas/cuartas y normalización de octava).
  - `meantone31`: Mesotónico de 1/4 de comma en 31-EDO.
  - `magic41`: Temperamento Mágico en 41-EDO con generador 3^(1/5).
  - `partch`: Ratios de justa entonación de Harry Partch (43 tonos).
  - `dalessandro`: Escala de Erv Wilson con base en Do4 = 256 Hz.
  - `centaur`: Escala Centaur de Kraig Grady (12 tonos, justa entonación límite 7).
- **Banco de Presets FM:**
  - `fmBell`: Campana tubular inarmónica clásica.
  - `fmBass`: Bajo sólido con pegada estilo LatelyBass (TX81Z / DX100).
  - `fmElectricPiano`: Piano eléctrico FM cálido y dinámico.
  - `fmAtmospherePad`: Textura envolvente para drones microtonales.
  - `fmHardLead`: Lead punzante y brillante.
- **Gestión de Recursos Robusta:**
  - Libre de *Voice Leaks* (seguimiento de nodos por canal y nota).
  - Etapa master con limitador integrado (`Limiter.ar`) para evitar distorsiones digitales.
  - Arranque sincronizado con `s.waitForBoot`.
  - Mapeo unificado para 3 canales MIDI (hasta 384 notas microtonales simultáneas) y mensajes OSC (`/mnote`, `/param/scale`, etc.).

---

## 📁 Estructura del Proyecto

```text
diesisRosa/
├── main.scd                 # Punto de entrada principal y orquestador
├── modules/
│   ├── engine.scd           # SynthDefs (\fmVoice, \masterStage), Buses y Grupos
│   ├── tunings.scd          # Catálogo matemático de afinaciones microtonales
│   ├── presets.scd          # Administrador del banco de presets FM
│   ├── voice_manager.scd    # Asignación polifónica segura y gestión de pánico
│   └── midi_osc.scd         # Controladores desacoplados de MIDI y OSC
├── presets/
│   └── default_presets.scd  # Diccionario persistente de timbres FM
├── origen/                  # Script monolítico original v1.0 de referencia
└── AUDIT_AND_DESIGN.md      # Reporte detallado de la auditoría técnica
```

---

## 🚀 Uso Rápido en SuperCollider

1. Abre SuperCollider IDE.
2. Abre el archivo `main.scd`.
3. Ejecuta todo el bloque con `Ctrl + Enter` (Windows/Linux) o `Cmd + Enter` (macOS).
4. El servidor se iniciará, compilará los SynthDefs y enlazará MIDI y OSC automáticamente.

### Comandos de Control en Vivo

```supercollider
// Cambiar de preset FM
~diesisRosa.setPreset(\fmBass);
~diesisRosa.setPreset(\fmElectricPiano);

// Cambiar de afinación microtonal
~diesisRosa.setTuning(\partch);
~diesisRosa.setTuning(\dalessandro);
~diesisRosa.setTuning(\tet31);

// Ajustar volumen master
~diesisRosa.setMasterVolume(0.3);

// Pánico (liberar notas colgadas)
~diesisRosa.panic;

// Limpieza total de recursos
~diesisRosa.cleanup;
```
