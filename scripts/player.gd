class_name Player
extends CharacterBody3D
## Jugador en 3a persona (spec 001): WASD relativo a camara, sprint Shift, E interactua.
## Velocidad base 4 m/s (GDD §67: granja->rio 30-60 s tunable aqui).

@export var speed: float = 4.0
@export var sprint_multiplier: float = 1.6

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var detector: Area3D = $InteractDetector

var nearby: Array[Area3D] = []
var current: Area3D = null
var current_prompt: String = ""


func _ready() -> void:
	detector.area_entered.connect(_on_area_entered)
	detector.area_exited.connect(_on_area_exited)


func _physics_process(delta: float) -> void:
	var input_vec: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var dir: Vector3 = spring_arm.global_transform.basis * Vector3(input_vec.x, 0.0, input_vec.y)
	dir.y = 0.0
	if dir.length() > 1.0:
		dir = dir.normalized()
	var mult: float = sprint_multiplier if Input.is_action_pressed("sprint") else 1.0
	velocity.x = dir.x * speed * mult
	velocity.z = dir.z * speed * mult
	if is_on_floor():
		velocity.y = 0.0
	else:
		velocity.y -= 20.0 * delta
	move_and_slide()
	if dir.length() > 0.1:
		rotation.y = lerp_angle(rotation.y, atan2(-dir.x, -dir.z), 10.0 * delta)
	_update_current()
	if Input.is_action_just_pressed("interact") and current != null and current.has_method("interact"):
		current.interact(self)


func _on_area_entered(area: Area3D) -> void:
	if area.has_method("get_prompt") and not nearby.has(area):
		nearby.append(area)


func _on_area_exited(area: Area3D) -> void:
	nearby.erase(area)


func _update_current() -> void:
	nearby = nearby.filter(func(a: Area3D) -> bool: return is_instance_valid(a))
	var best: Area3D = null
	var best_d := INF
	for area: Area3D in nearby:
		var d: float = global_position.distance_to(area.global_position)
		if d < best_d:
			best_d = d
			best = area
	current = best
	if current != null:
		current_prompt = "E: " + String(current.get_prompt())
	else:
		current_prompt = ""
