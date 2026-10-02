# 002 — Tiempo día/noche + dormir/guardar (spec)

- Constitution: R5 (mundo vivo), pilar Naturaleza.
- GDD §§7-8, §39, §61, §80.

## QUÉ
Día 15-25 min configurable (default 20). Reloj 06:00→noche, fases amanecer/día/atardecer/noche con luz cálida→dorada→oscura.
Dormir en cama: Day+1, hora 06:00, autosave. Acostarse tarde → cansancio/menos energía (simple: energía 70% si duermes tras 00:00).
Guardado manual + autosave en `user://savegame.json` con versión.

## Criterios
- [ ] Ciclo completo sin errores, estrellas visibles de noche despejada.
- [ ] Dormir guarda y recarga posición/día/inventario/animales/cultivos.
