class_name Animal
extends CharacterBody3D
## Animal-compañero data-driven (GDD §§14-22, spec 005): nombre, personalidad,
## hambre/hidratacion/felicidad/afecto, produccion diaria si esta cuidado.
## El perro sigue al jugador; nunca hay muerte (GDD §55).

@export var data: AnimalData
@export var animal_name: String = "Animal"
@export var personality: String = "tranquilo"

var hunger: float = 80.0
var hydration: float = 80.0
var happiness: float = 70.0
var affection: float = 0.0
var pending: int = 0
var is_baby: bool = false
var age_days: int = 0
var sick: bool = false

const GROW_DAYS := 3
const MAX_HERD := 12

var _target := Vector3.ZERO
var _idle_t := 0.0

@onready var body: MeshInstance3D = $Body
@onready var name_label: Label3D = $NameLabel


func _ready() -> void:
	add_to_group("animals")
	if data != null:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = data.tint
		body.set_surface_override_material(0, mat)
		body.scale = data.body_size / Vector3(0.6, 0.6, 0.8)
	name_label.text = animal_name + (" (bebé)" if is_baby else "")
	if is_baby:
		_apply_baby_scale()
	_target = global_position


func _apply_baby_scale() -> void:
	var f: float = 0.55 + 0.45 * clampf(float(age_days) / float(GROW_DAYS), 0.0, 1.0)
	scale = Vector3.ONE * f


func _physics_process(delta: float) -> void:
	hunger = maxf(0.0, hunger - delta * 0.05)
	hydration = maxf(0.0, hydration - delta * 0.06)
	var night: bool = false
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	if time_sys != null and time_sys.has_method("is_night"):
		night = bool(time_sys.call("is_night"))
	var dir := Vector3.ZERO
	if not night:
		if data != null and data.follows_player:
			var players: Array[Node] = get_tree().get_nodes_in_group("player")
			if not players.is_empty():
				var pp: Vector3 = (players[0] as Node3D).global_position
				if global_position.distance_to(pp) > 2.5:
					dir = (pp - global_position).normalized()
		if dir == Vector3.ZERO:
			_idle_t -= delta
			if _idle_t <= 0.0 or global_position.distance_to(_target) < 0.5:
				_target = global_position + Vector3(randf_range(-4.0, 4.0), 0.0, randf_range(-4.0, 4.0))
				_idle_t = randf_range(2.0, 6.0)
			dir = (_target - global_position).normalized()
	var spd: float = data.walk_speed if data != null else 1.2
	if data != null and data.follows_player and dir != Vector3.ZERO and _is_following():
		spd = 3.2
	velocity.x = dir.x * spd
	velocity.z = dir.z * spd
	velocity.y = 0.0 if is_on_floor() else velocity.y - 20.0 * delta
	move_and_slide()
	if dir.length() > 0.1:
		rotation.y = lerp_angle(rotation.y, atan2(-dir.x, -dir.z), 5.0 * delta)


func _is_following() -> bool:
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return false
	return global_position.distance_to((players[0] as Node3D).global_position) > 2.5


func get_prompt() -> String:
	if sick:
		return animal_name + " está enfermo (veterinaria)"
	if is_baby:
		return "Bebé " + animal_name
	if pending > 0 and data != null and data.produce_id != "":
		return "Recoger " + data.produce_id
	if hunger < 50.0:
		return "Alimentar a " + animal_name
	return "Acariciar a " + animal_name


func interact(player: Node) -> void:
	if hunger < 70.0 and data != null and data.food_id != "":
		var inv: Node = get_node_or_null("/root/InventorySystem")
		if inv != null and bool(inv.call("remove_item", data.food_id)):
			feed()
			return
	if pending > 0:
		collect()
	else:
		pet()


func feed() -> void:
	hunger = minf(100.0, hunger + 45.0)
	hydration = minf(100.0, hydration + 20.0)
	happiness = minf(100.0, happiness + 5.0)


func pet() -> void:
	affection = minf(100.0, affection + 10.0)
	happiness = minf(100.0, happiness + 8.0)


func collect() -> String:
	if pending <= 0 or data == null or data.produce_id == "":
		return ""
	pending -= 1
	var inv: Node = get_node_or_null("/root/InventorySystem")
	if inv != null:
		inv.call("add_item", data.produce_id)
	return data.produce_id


func new_day() -> void:
	hunger = maxf(0.0, hunger - 25.0)
	hydration = maxf(0.0, hydration - 30.0)
	if hunger <= 0.0 and not is_baby:
		sick = true
	if is_baby:
		if hunger > 30.0:
			age_days += 1
			_apply_baby_scale()
			if age_days >= GROW_DAYS:
				is_baby = false
				scale = Vector3.ONE
				name_label.text = animal_name
		return
	if sick:
		happiness = maxf(0.0, happiness - 15.0)
		return
	if hunger > 40.0 and hydration > 40.0 and data != null and data.produce_id != "":
		pending = mini(3, pending + data.produce_per_day)
		happiness = minf(100.0, happiness + 5.0)
	else:
		happiness = maxf(0.0, happiness - 10.0)


func cure() -> void:
	sick = false
	happiness = minf(100.0, happiness + 20.0)


func serialize() -> Dictionary:
	return {"name": animal_name, "hunger": hunger, "hydration": hydration,
		"happiness": happiness, "affection": affection, "pending": pending,
		"is_baby": is_baby, "age_days": age_days, "sick": sick,
		"species": String(data.species) if data != null else "",
		"personality": personality,
		"pos": [global_position.x, global_position.y, global_position.z]}


func deserialize(d: Dictionary) -> void:
	hunger = float(d.get("hunger", 80.0))
	hydration = float(d.get("hydration", 80.0))
	happiness = float(d.get("happiness", 70.0))
	affection = float(d.get("affection", 0.0))
	pending = int(d.get("pending", 0))
	is_baby = bool(d.get("is_baby", false))
	age_days = int(d.get("age_days", 0))
	sick = bool(d.get("sick", false))
	if d.has("pos") and typeof(d["pos"]) == TYPE_ARRAY and (d["pos"] as Array).size() == 3:
		var a: Array = d["pos"]
		global_position = Vector3(float(a[0]), float(a[1]), float(a[2]))
	if is_baby:
		_apply_baby_scale()
	else:
		scale = Vector3.ONE
	name_label.text = animal_name + (" (bebé)" if is_baby else "")
