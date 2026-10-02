# 001 plan (Godot)
- `scenes/Player.tscn` (CharacterBody3D+Capsule+Camera SpringArm), `scripts/Player.cs`, `scripts/components/InteractableArea3D.cs`.
- InputMap: move_*, sprint, interact(E). Velocidad base ~4 m/s (tunable para §67).
- Verificación: abrir `Main.tscn`, caminar 10s, acercarse a cubo-interactuable, prompt+E funciona.
