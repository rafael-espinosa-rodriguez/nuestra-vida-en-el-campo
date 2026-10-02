# 001 plan (Godot)
- `scenes/Player.tscn` (CharacterBody3D+Capsule+Camera SpringArm), `scripts/player.gd`, `scripts/components/interactable_area.gd`.
- InputMap: move_*, sprint, interact(E). Velocidad base ~4 m/s (tunable para §67).
- Verificación: abrir `Main.tscn`, caminar 10s, acercarse a cubo-interactuable, prompt+E funciona.
