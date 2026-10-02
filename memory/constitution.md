# Constitution — Nuestra Vida en el Campo (v1.0, Spec-Kit)

> Fuente: GDD v1.0 §§3, 4, 62, 82, 91. Este archivo es ley. Cualquier spec que lo viole debe rechazarse.

## 1. Identidad
Simulador de vida rural cozy en el campo de Azerbaiyán. 3D tercera persona, single-player, PC.
Fantasía: "¿Cómo sería nuestra vida si dejáramos la ciudad y viviéramos en una pequeña casa en el campo?"

## 2. Los 5 pilares (toda mecánica nueva debe aportar a al menos uno)
1. **Hogar** — la casa se construye emocionalmente, no solo se mejora.
2. **Animales-compañeros** — con nombre, personalidad, rutina, relación. Nunca máquinas de recursos.
3. **Autosuficiencia** — cadenas conectadas (trigo→harina→pan, leche→queso). Ecosistema, no grind.
4. **Naturaleza viva** — estaciones, clima, día/noche, sonido ambiente, movimiento aun sin input.
5. **Tranquilidad** — espacio para descansar, pasear, decorar, mirar estrellas. Sin presión constante.

## 3. Lo que el juego NO debe ser
- Supervivencia extrema, granja industrial, RPG de combate, carrera por dinero.
- Misiones obligatorias en cadena, presión por optimizar cada minuto, clon de Stardew Valley.

## 4. Reglas maestras
- **R1 — Pregunta de diseño (§62/§91):** "¿Esto hace que vivir en el campo sea más interesante o solo añade trabajo?" Si solo añade trabajo sin diversión → se elimina o simplifica.
- **R2 — Anti-grind (§83):** prohibido "repite 100 veces una tarea aburrida para conseguir X". Cada sistema nuevo debe abrir una posibilidad nueva, no un +10% productividad.
- **R3 — Animales (§55, §84):** nunca muerte cruel/inesperada por mecánicas normales. Enferman, se cuidan, envejecen. Siempre visibles, con sonido, rutina y reacción al jugador.
- **R4 — Casa (§85):** debe evolucionar visualmente (foto día 1 vs día 100 claramente distinta).
- **R5 — Naturaleza (§86):** el mundo se mueve solo: árboles, pájaros, nubes, agua, hojas.
- **R6 — Momento perfecto (§87):** diseñar para momentos espontáneos sin UI (nieve/perro/chimenea/atardecer). Sin popups que rompan la magia.
- **R7 — Un sistema genérico (§78-79):** `AnimalSystem` (no CowSystem/ChickenSystem), `Interact()` genérico (puerta/vaca/horno/NPC/cultivo). Datos en `Resource`, no código duplicado.

## 5. Métrica de éxito (§82)
No: dinero, horas, nº objetos. Sí: **"¿Me gustaría pasar otro día aquí?"**
- 10h: "ya conozco mi granja" / 30h: "estos animales son mis animales" / 60h: "esta casa es mi casa" / 100h: "no quiero abandonar este lugar".

## 6. Proceso spec-driven obligatorio
`spec.md` → `plan.md` → `tasks.md` → código → verificación en editor → evidencia pegada en la tarea.
Sin spec aprobada no hay código. Un sistema a la vez.
