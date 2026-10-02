# 001 — Movimiento, cámara, interacción (spec)

- Constitution: R7 (interacción genérica), pilar Tranquilidad (caminar agradable).
- GDD: §§prioridad 1-3, §79, §67 distancias cortas.

## QUÉ
Player CharacterBody3D en 3ª persona: WASD + sprint (consume energía, ver spec 006), cámara con zoom/colisión suave,
detección del `IInteractable` más cercano + prompt + tecla E. Todo interactuable futuro (puerta/vaca/horno/cultivo) usa esto.

## Criterios aceptados
- [ ] WASD mueve relativo a cámara, sprint con Shift, sin jitter.
- [ ] Acercarse a gallina muestra "E: Acariciar" (placeholder) y E lo dispara.
- [ ] Caminar granja→río se siente 30-60s a velocidad base (tunable).
