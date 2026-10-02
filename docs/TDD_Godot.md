# TDD — Arquitectura Godot + C# (v1.0)

## 1. Proyecto
- Godot 4.x .NET, `project.godot` con `config/features=["C#"]`, renderer `gl_compatibility`.
- Assembly `NuestraVidaEnElCampo`. Solo C#. Escenas `.tscn`, scripts `.cs`, datos `.tres`.

## 2. Autoloads (orden)
1. `TimeSystem` — hora/día, dormir→Day+1+autosave.
2. `WeatherSystem` — soleado/nublado/lluvia (D6 lluvia forzada MVP).
3. `SaveSystem` — `user://savegame.json` (posición, día, estación=primavera, clima, inventario, animales, cultivos, dinero, recuerdos).
4. `InventorySystem` — categorías §59 + conteo simple.
5. `FarmingSystem` — parcelas (suelo/humedad/calidad/etapa), plantar/regar/cosechar.
6. `AnimalSystem` — único para todas las especies. Feed/Pet/Collect. Datos en `AnimalData`.
7. `AudioSystem` — ambience + música puntual.

## 3. Interacción
- `IInteractable` (`GetPrompt()`, `Interact(Player)`). `InteractableArea3D : Area3D` con export `Prompt`.
- Player `CharacterBody3D`, raycast/Area detecta el interactuable más cercano, tecla `E` (InputMap `interact`).

## 4. Datos (Resources)
- `AnimalData(tres)`: gallina→huevo, vaca→leche, perro→compañía. Nombres y personalidad.
- `CropData`: trigo 3 días, zanahoria 2, tomate 4 (primavera). Necesitan agua.
- `RecipeData`: pan (harina+agua, horno), sopa (papa+cebolla+zanahoria), tortilla (huevo+verdura).
- `ItemData`: id, nombre, categoría, icono, stack máximo.

## 5. Escenas MVP
`Main.tscn` (WorldEnvironment+DirectionalLight+granja base) → `House.tscn` (cama+chimenea+horno),
`Plot.tscn`, `Chicken.tscn`, `Cow.tscn`, `Dog.tscn`, `Player.tscn`, `UI/HUD.tscn`.

## 6. Guardado robusto
- Autosave al dormir + manual. Versión de save (`version:1`). Carga tolerante a campos faltantes.

## 7. Verificación por spec
Cada spec trae checklist jugable en editor (escena, pasos, resultado esperado). Sin checklist verde no se cierra.
