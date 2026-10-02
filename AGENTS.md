# AGENTS.md — Nuestra Vida en el Campo

> Instrucciones obligatorias para cualquier agente IA o humano que programe en este repo.
> Stack: **Godot 4.x (.NET / C# únicamente)**. Metodología: **GitHub Spec-Kit (spec-driven)**.
> Repo GitHub: `nuestra-vida-en-el-campo`. MVP: **semana completa jugable en primavera**.

## 1. Cómo trabajar aquí (spec-driven, siempre)

1. **Nunca programes sin spec aprobada.** El flujo es:
   `specs/<NNN-nombre>/spec.md` (QUÉ) → `plan.md` (CÓMO en Godot) → `tasks.md` (pasos atómicos) → código → verificación.
2. Cada spec debe citar la **constitution** (`memory/constitution.md`) y la sección del GDD (`docs/GDD_v1.1_Godot.md`).
3. Un sistema a la vez. Prohibido implementar 50 sistemas en paralelo (GDD §94).
4. Antes de dar por hecha una tarea, ejecuta la verificación declarada en su `tasks.md` y pega la evidencia.

## 2. Stack y comandos

- **Godot 4.x versión .NET** (no la clásica), **.NET 8 SDK**, C# 12. No GDScript. Todo el gameplay en C#.
- Abrir el proyecto: `godot --path "D:/SALVA NO BORRAR NUESTRA VIDA EN EL CAMPO"` (o doble clic en `project.godot`).
- Compilar C#: lo hace Godot al abrir/guardar. Desde terminal (con SDK instalado): `dotnet build`.
- Tests: de momento verificación manual en editor + checklist de cada spec. Cuando haya GUT/DotNet tests, `dotnet test`.
- Requisitos pendientes en esta máquina: instalar **Godot 4 .NET**, **.NET 8 SDK** y `gh` CLI. Ver `docs/Setup.md`.

## 3. Convenciones Godot + C#

- `scripts/systems/` → Autoloads singletons: `TimeSystem, WeatherSystem, SaveSystem, InventorySystem, FarmingSystem, AnimalSystem, CraftingSystem, CookingSystem, AudioSystem`.
- `scripts/components/` → componentes reutilizables (`InteractableArea`, `Health`, `Hunger`, `Growable`).
- `scripts/data/` → clases `Resource`: `AnimalData, CropData, RecipeData, ItemData`. Datos en `resources/data/**` como `.tres`.
- `scripts/ui/` → solo UI. `scenes/` → escenas por feature. `assets/` → arte low-poly + audio (usar Git LFS).
- Nombres: clases `PascalCase`, métodos `PascalCase`, campos privados `_camelCase`, señales `PascalCase`, nodos en escenas `PascalCase`.
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
- Archivos C# + escenas + recursos `.tres` necesarios, nada más.
- Cómo se probó en el editor (escena abierta, pasos, captura si hay UI).
- Sin binarios pesados fuera de LFS. Sin secretos. Sin `Library/`, `.godot/`, `bin/`, `obj/` (ignorados por git).
