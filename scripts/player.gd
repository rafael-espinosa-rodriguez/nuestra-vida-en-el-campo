class_name Player
extends CharacterBody3D
## Jugador en 3a persona. TODO spec 001: movimiento relativo a camara + sprint + Interact(E).

@export var speed: float = 4.0


func _physics_process(_delta: float) -> void:
	var input_vec: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var dir := Vector3(input_vec.x, 0.0, input_vec.y)
	velocity = dir * speed
	move_and_slide()
