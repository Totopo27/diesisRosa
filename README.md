# diesisRosa

Sintetizador microtonal modular programado en SuperCollider. Combina afinaciones históricas y experimentales con un motor de modulación en frecuencia (FM) de tres operadores en cascada y control por MIDI y OSC.

---

## Qué hace

El proyecto nació para superar la restricción de los doce semitonos del teclado convencional sin perder la estabilidad del sintetizador en vivo. En lugar de un archivo único con variables globales y disparadores manuales, el código corre dividido en módulos independientes: motor de audio, tablas de cálculo de afinación, banco de timbres, gestor de polifonía y receptores de control.

### Afinaciones disponibles

Cada escala calcula un arreglo de 384 posiciones de frecuencia para responder a tres canales MIDI contiguos (hasta 384 teclas mapeadas sin saltos):

- **tet12**: Temperamento igual estándar de 12 divisiones.
- **tet31, tet41, tet53**: Temperamentos iguales extendidos.
- **pitag53**: Escala pitagórica construida mediante 26 quintas y 26 cuartas acomodadas dentro de 53-EDO, con normalización de octava.
- **meantone31**: Mesotónico de un cuarto de coma (Aron) organizado en 31-EDO.
- **magic41**: Temperamento Mágico en 41 notas por ciclo usando el generador $3^{1/5}$.
- **partch**: Sistema de 43 tonos en justa entonación de Harry Partch con frecuencia base en Sol 0 (24.5 Hz).
- **dalessandro**: Afinación de Erv Wilson construida sobre Do 4 = 256 Hz.
- **centaur**: Escala de 12 grados de Kraig Grady en justa entonación (límite 7).

### Banco de sonido FM

Los timbres están definidos en diccionarios desacoplados según relaciones de portadora y moduladores ($C:M$):

- `\fmBell`: Campana inarmónica con proporciones de Chowning ($1 : 1.414 : 3.5$) y caída exponencial de brillo.
- `\fmBass`: Bajo sólido estilo TX81Z / LatelyBass con ataque percusivo rápido en el segundo modulador.
- `\fmElectricPiano`: Timbre de piano electromecánico con modulador agudo transitorio emulando la barra metálica.
- `\fmAtmospherePad`: Textura lenta con batimiento interno diseñada para acordes microtonales densos.
- `\fmHardLead`: Espectro cortante basado en armónicos impares ($1 : 3 : 5$).

---

## Estructura

```text
diesisRosa/
├── main.scd                 # Arranque sincronizado con s.waitForBoot
├── modules/
│   ├── engine.scd           # SynthDefs (\fmVoice, \masterStage), buses y limitador
│   ├── tunings.scd          # Fórmulas y arreglos de las 10 afinaciones
│   ├── presets.scd          # Carga y serialización de timbres FM
│   ├── voice_manager.scd    # Polifonía protegida contra notas colgadas
│   └── midi_osc.scd         # Enrutamiento de mensajes MIDI (ch 1, 2, 3) y OSC
├── presets/
│   └── default_presets.scd  # Definición de parámetros tímbricos
├── origen/                  # Script inicial de referencia
└── AUDIT_AND_DESIGN.md      # Diagnóstico técnico de la refactorización
```

---

## Cómo usarlo

1. Abrí `main.scd` en SuperCollider IDE.
2. Ejecutá el bloque principal (`Ctrl+Enter` en Windows/Linux o `Cmd+Enter` en macOS).
3. El servidor arrancará, compilará los sintetizadores y enlazará las entradas MIDI y OSC en el puerto `57120`.

### Control en tiempo real

```supercollider
// Cambiar el timbre activo
~diesisRosa.setPreset(\fmElectricPiano);
~diesisRosa.setPreset(\fmAtmospherePad);

// Cambiar el sistema de afinación
~diesisRosa.setTuning(\dalessandro);
~diesisRosa.setTuning(\tet31);
~diesisRosa.setTuning(\partch);

// Ajustar el nivel general de salida
~diesisRosa.setMasterVolume(0.2);

// Pánico suave (envía gate 0 a todas las voces activas)
~diesisRosa.panic;

// Apagar el sintetizador y liberar grupos, buses y listeners
~diesisRosa.cleanup;
```

### Mensajes OSC admitidos

- `/mnote [nota, velocidad]`: Dispara o libera una voz.
- `/param/a/octave [entero]`: Transpone por octavas hacia arriba o hacia abajo.
- `/param/scale [nombre]`: Cambia la afinación activa (ej. `\tet41`).
- `/param/preset [nombre]`: Cambia el sonido activo (ej. `\fmBass`).
- `/allnotesoff`: Pánico suave respetando la curva de release.
- `/allsoundoff`: Pánico duro que destruye los nodos al instante.
