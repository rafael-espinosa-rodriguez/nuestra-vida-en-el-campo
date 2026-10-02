# GDD v1.1 — Nuestra Vida en el Campo (Godot + C#)

> Adaptación del GDD v1.0 (documento Word original) a **Godot 4.x .NET + C#**.
> Cambio principal: §75 motor Unity → Godot. Resto de visión, pilares y MVP se mantienen.

## Cambios v1.0 → v1.1
- Motor: **Godot 4.x versión .NET** (pesa menos que Unity, open-source, ideal para prototipo cozy). Lenguaje único: **C# 12, .NET 8**. Sin GDScript.
- `ScriptableObjects` → `Resource` C# (`.tres` en `resources/data/`).
- `MonoBehaviour/Manager` → `Nodos + Autoloads` (`TimeSystem, WeatherSystem, SaveSystem, InventorySystem, FarmingSystem, AnimalSystem, CraftingSystem, CookingSystem, AudioSystem`).
- UI: `uGUI` → `Control` nodos Godot. Input: `InputMap`.
- Render: `URP` → `GL Compatibility` (ligero, PCs modestas) con opción a `Forward+` más adelante.
- Guardado: `JSON` en `user://savegame.json`.

## Resumen fiel al original (no se recorta visión)
- **Género:** simulación vida rural / farming / cozy / crafting. 3D tercera persona, single-player, PC, campo Azerbaiyán, tono tranquilo.
- **Fantasía:** "¿Cómo sería nuestra vida si dejáramos la ciudad?" Rutina: levantarse, animales, desayuno, huevos, ordeñar, huerto, cocinar, pasear, chimenea, lluvia, dormir.
- **Pilares:** Hogar, Animales-compañeros, Autosuficiencia, Naturaleza viva, Tranquilidad.
- **Historia:** propiedad familiar abandonada (casa+establo+gallinero+pozo+huerto). Actos: llegar → establecerse → hogar → autosuficiencia → vida soñada.
- **Bucle:** despertar → casa → animales → cultivos → recolectar → procesar → cocinar/vender → explorar/socializar → preparar mañana → dormir.
- **Día 15-25 min, 06:00 a 21:00-00:00.** Energía: talar/regar/cosechar consumen; caminar/cocinar no. Recupera con comida/sueño.
- **MVP semana completa (primavera):** mundo granja+casa+bosque+río+camino pueblo; 3 gallinas (Misha/Zara/Lola) + 1 vaca + 1 perro; trigo/tomate/zanahoria; huevo/leche/pan/sopa; día-noche, clima soleado/nublado/lluvia, hambre animal, energía, inventario, cocina, dormir/guardar.
- **Guion D1-D7:** D1 llegada, D2 gallinas/huevo, D3 plantar, D4 ordeñar, D5 cocinar, D6 lluvia+chimenea, D7 atardecer ("esto puede ser nuestro hogar").
- **Fuera MVP:** ovejas/cabras/gato/caballo, verano/otoño/invierno jugables, NPC/relaciones/mercado, reproducción, foto/recuerdos, multi.

Ver documento Word original (`.doc` en Descargas) como referencia completa §§1-94. Esta v1.1 solo fija decisiones técnicas Godot.
