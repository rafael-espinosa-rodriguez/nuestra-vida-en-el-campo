# Nuestra Vida en el Campo

Simulador de vida rural cozy (Godot 4 clásica + GDScript). Single-player, PC, 3D tercera persona.
Campo de Azerbaiyán. MVP: **semana completa jugable en primavera**.

> Metodología: GitHub Spec-Kit. Lee primero `AGENTS.md` y `memory/constitution.md`.

## Estado
FASE 0 — Preproducción / scaffolding. Sin gameplay aún.

## Requisitos
- Godot 4.x **versión clásica** 4.7.2 (instalada en `%LOCALAPPDATA%\Programs\Godot`)
- Git + Git LFS. Opcional: `gh` CLI para GitHub.

Ver `docs/Setup.md`.

## Abrir el proyecto
```
godot --path "D:/SALVA NO BORRAR NUESTRA VIDA EN EL CAMPO"
```

## Estructura
- `memory/constitution.md` — reglas no negociables
- `docs/` — GDD v1.1 Godot, TDD, Arte, Roadmap, Setup
- `specs/` — una carpeta por feature: `spec.md` + `plan.md` + `tasks.md`
- `scripts/systems|components|data|ui` — código GDScript (únicamente, sin C#)
- `scenes/`, `resources/data/`, `assets/` — escenas, datos `.tres`, arte low-poly

## MVP (resumen)
Granja+casa+bosque+río+camino pueblo. 3 gallinas + 1 vaca + 1 perro.
Cultivos trigo/tomate/zanahoria. Productos huevo/leche/pan/sopa.
Día-noche, clima soleado/nublado/lluvia, energía, hambre animal, inventario, cocina, dormir/guardar.
Guion D1-D7: ver `specs/008-semana-primavera/spec.md`.

## Repo GitHub
Nombre oficial: **`nuestra-vida-en-el-campo`**.
Si aún no existe en GitHub, créalo vacío con ese nombre y luego:
```
git remote add origin https://github.com/<tu-usuario>/nuestra-vida-en-el-campo.git
git branch -M main
git push -u origin main
```
