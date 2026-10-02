# AGENTS.md — Nuestra Vida en el Campo

> Instrucciones obligatorias para cualquier agente IA o humano que programe en este repo.
> Stack: **Godot 4.x clásica (GDScript únicamente)**. Metodología: **GitHub Spec-Kit (spec-driven)**.
> Repo GitHub: `nuestra-vida-en-el-campo`. MVP: **semana completa jugable en primavera**.

## 1. Cómo trabajar aquí (spec-driven, siempre)

1. **Nunca programes sin spec aprobada.** El flujo es:
   `specs/<NNN-nombre>/spec.md` (QUÉ) → `plan.md` (CÓMO en Godot) → `tasks.md` (pasos atómicos) → código → verificación.
2. Cada spec debe citar la **constitution** (`memory/constitution.md`) y la sección del GDD (`docs/GDD_v1.1_Godot.md`).
3. Un sistema a la vez. Prohibido implementar 50 sistemas en paralelo (GDD §94).
4. Antes de dar por hecha una tarea, ejecuta la verificación declarada en su `tasks.md` y pega la evidencia.

## 2. Stack y comandos

- **Godot 4.x versión clásica** (instalada en `%LOCALAPPDATA%\Programs\Godot`, v4.7.2). **GDScript únicamente**, sin C#.
- Abrir el proyecto: doble clic en `project.godot` o `Godot_v4.7.2-stable_win64.exe --path "D:/SALVA NO BORRAR NUESTRA VIDA EN EL CAMPO"`.
- Sin compilación: GDScript se interpreta. Verificación headless: `Godot_v4.7.2-stable_win64_console.exe --headless --path "..." --import`.
- Tests: de momento verificación manual en editor + checklist de cada spec. Cuando haya tests GUT, se documentan en la spec.
- Plugin MCP **Godot MCP Toolkit** en `addons/` + servidor `godot` registrado en opencode (`npx -y @npgamedev/godot-mcp-server`). Requiere editor abierto con el plugin activo. Ver `docs/MCP.md`.
- `gh` CLI v2.102.0 instalado (en PATH). Sin auth aún: el primer `gh auth login` lo hace el usuario en su terminal. Git LFS pendiente. Ver `docs/Setup.md`.

## 3. Convenciones Godot + GDScript

- `scripts/systems/` → Autoloads singletons: `TimeSystem, WeatherSystem, SaveSystem, InventorySystem, FarmingSystem, AnimalSystem, CraftingSystem, CookingSystem, AudioSystem` (archivos `snake_case.gd`, `class_name` cuando sea dato).
- `scripts/components/` → componentes reutilizables (`InteractableArea`, `Health`, `Hunger`, `Growable`).
- `scripts/data/` → clases `Resource`: `AnimalData, CropData, RecipeData, ItemData`. Datos en `resources/data/**` como `.tres`.
- `scripts/ui/` → solo UI. `scenes/` → escenas por feature. `assets/` → arte low-poly + audio (usar Git LFS).
- Nombres: clases y `class_name` en `PascalCase`, archivos en `snake_case.gd`, funciones/variables/señales en `snake_case`, constantes en `UPPER_SNAKE`, nodos en escenas `PascalCase`.
- Interacción genérica obligatoria: todo interactuable implementa `IInteractable` (`GetPrompt()`, `Interact(Player)`). Nada de lógica de input repartida.
- Un `AnimalSystem`, no `CowSystem/ChickenSystem`. Los animales son **datos diferentes**, no sistemas diferentes (principio §78 GDD).
- Guardado robusto en `user://savegame.json`: posición, día, estación, clima, inventario, animales, cultivos, edificios, dinero, recuerdos.

## 4. Reglas de diseño (no negociables)

Ver `memory/constitution.md`. Resumen: hogar + animales-compañeros + autosuficiencia + naturaleza viva + tranquilidad.
Prohibido: supervivencia extrema, granja industrial, combate RPG, grind (+10% productividad sin diversión), muerte cruel de animales, presión constante, clon de Stardew Valley.

## 5. Alcance MVP vigente

**Semana completa en primavera** (otoño/invierno solo como diseño, no implementados):
mundo granja+casa+bosque pequeño+río+camino pueblo; jugador moverse/interactuar/inventario/herramientas;
3 gallinas + 1 vaca + 1 perro; cultivos trigo/tomate/zanahoria; productos huevo/leche/pan/sopa;
sistemas día-noche, clima básico (soleado/nublado/lluvia), hambre animal, energía, agricultura, inventario, cocina, dormir/guardar.
Guion D1-D7 en `specs/008-semana-primavera/spec.md`. Métrica de éxito: "¿Me gustaría pasar otro día aquí?".

## 6. Arte

Low-poly estilizado desde el inicio, identidad rural azerbaiyana (madera/piedra/techo inclinado, textiles), paleta primavera (verdes suaves + flores). Distancias cortas: granja→río 30-60s, granja→bosque ~1min, granja→pueblo 1-2min. Detalle en `docs/Arte.md`.

## 7. Qué debe contener cada PR/commit

- Referencia a la spec (`specs/00X-...`).
- Archivos GDScript + escenas + recursos `.tres` necesarios, nada más.
- Cómo se probó en el editor (escena abierta, pasos, captura si hay UI).
- Sin binarios pesados fuera de LFS. Sin secretos. Sin `Library/`, `.godot/`, `bin/`, `obj/` (ignorados por git).
