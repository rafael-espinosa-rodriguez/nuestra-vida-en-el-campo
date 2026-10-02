class_name NPC
extends CharacterBody3D
## Vecino con rutina diaria (GDD §42, spec 010): casa -> trabajo -> plaza -> casa.
## E conversa: linea segun momento, visible sobre su cabeza unos segundos.

@export var data: NPCData
@export var npc_name: String = "Vecino"
@export var home_pos: Vector3 = Vector3.ZERO
@export var work_pos: Vector3 = Vector3.ZERO
@export var plaza_pos: Vector3 = Vector3.ZERO

var last_line: String = ""

var _target := Vector3.ZERO
var _say_t := 0.0

@onready var body: MeshInstance3D = $Body
@onready var name_label: Label3D = $NameLabel
@onready var say_label: Label3D = $SayLabel


func _ready() -> void:
	add_to_group("npcs")
	if data != null:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = data.tint
		body.set_surface_override_material(0, mat)
	name_label.text = npc_name
	_target = home_pos if home_pos != Vector3.ZERO else global_position
	say_label.visible = false


func _physics_process(delta: float) -> void:
	update_schedule()
	var dir: Vector3 = _target - global_position
	dir.y = 0.0
	if dir.length() > 0.6:
		dir = dir.normalized()
		velocity.x = dir.x * 2.0
		velocity.z = dir.z * 2.0
		rotation.y = lerp_angle(rotation.y, atan2(-dir.x, -dir.z), 5.0 * delta)
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	velocity.y = 0.0 if is_on_floor() else velocity.y - 20.0 * delta
	move_and_slide()


func _process(delta: float) -> void:
	if _say_t > 0.0:
		_say_t -= delta
		if _say_t <= 0.0:
			say_label.visible = false


func moment_key() -> String:
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	var h: float = 10.0
	if time_sys != null:
		h = float(time_sys.get("hour"))
	var weather: Node = get_node_or_null("/root/WeatherSystem")
	if weather != null and int(weather.get("current")) == 2:
		return "lluvia"
	if h < 9.0:
		return "manana"
	if h < 14.0:
		return "dia"
	if h < 20.0:
		return "tarde"
	return "noche"


func update_schedule() -> void:
	match moment_key():
		"manana", "noche", "lluvia":
			_target = home_pos
		"dia":
			_target = work_pos
		"tarde":
			_target = plaza_pos


func get_prompt() -> String:
	return npc_name + ": Hablar"


func interact(_player: Node) -> void:
	talk()


func talk() -> String:
	var key := moment_key()
	var lines: Array = []
	if data != null and data.dialogues.has(key):
		lines = Array(data.dialogues[key])
	if lines.is_empty() and data != null and data.dialogues.has("dia"):
		lines = Array(data.dialogues["dia"])
	if lines.is_empty():
		lines = ["Hola."]
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	var day: int = int(time_sys.get("current_day")) if time_sys != null else 1
	last_line = String(lines[day % lines.size()])
	say_label.text = last_line
	say_label.visible = true
	_say_t = 5.0
	return last_line
