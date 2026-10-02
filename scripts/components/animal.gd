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
var ridden: bool = false

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
		_build_model()
	name_label.text = animal_name + (" (bebé)" if is_baby else "")
	if is_baby:
		_apply_baby_scale()
	_target = global_position


func _part(size: Vector3, pos: Vector3, color: Color) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh.material = null
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	mi.set_surface_override_material(0, mat)
	mi.position = pos
	add_child(mi)
	return mi


func _build_model() -> void:
	# Modelo low-poly por especie con primitivas (spec 020): cabeza, patas, orejas, cola.
	var tint: Color = data.tint
	var dark: Color = tint.darkened(0.25)
	var size: Vector3 = data.body_size
	var species: String = data.species
	var legs := 4
	var leg_len := 0.55
	var head_size := Vector3(0.35, 0.35, 0.35)
	match species:
		"gallina":
			legs = 2
			leg_len = 0.35
			head_size = Vector3(0.28, 0.28, 0.28)
		"gato":
			leg_len = 0.35
			head_size = Vector3(0.3, 0.3, 0.3)
		"vaca":
			leg_len = 0.7
			head_size = Vector3(0.45, 0.45, 0.5)
		"caballo":
			leg_len = 0.7
			head_size = Vector3(0.4, 0.45, 0.55)
	var body_bottom: float = leg_len - 0.6
	var body_center: float = body_bottom + size.y * 0.5
	body.position.y = body_center
	var head_y: float = body_center + size.y * 0.5 + head_size.y * 0.5 - 0.05
	var head_z: float = -(size.z * 0.5 + head_size.z * 0.5 - 0.05)
	_part(head_size, Vector3(0, head_y, head_z), tint.darkened(0.08))
	var lx: float = maxf(0.1, size.x * 0.5 - 0.08)
	var lz: float = maxf(0.1, size.z * 0.5 - 0.1)
	for i: int in legs:
		var sx := -lx if i % 2 == 0 else lx
		var sz := -lz if i < 2 else lz
		if legs == 2:
			sz = 0.0
		var leg := MeshInstance3D.new()
		var lm := BoxMesh.new()
		lm.size = Vector3(0.12, leg_len, 0.12)
		leg.mesh = lm
		var lmat := StandardMaterial3D.new()
		lmat.albedo_color = dark
		leg.set_surface_override_material(0, lmat)
		leg.position = Vector3(sx, body_bottom - leg_len * 0.5, sz)
		add_child(leg)
	_part(Vector3(0.15, 0.15, 0.35), Vector3(0, body_center + 0.1, size.z * 0.5 + 0.1), dark)
	match species:
		"gallina":
			_part(Vector3(0.12, 0.12, 0.15), Vector3(0, head_y, head_z - head_size.z * 0.5 - 0.05), Color(1.0, 0.6, 0.2))
			_part(Vector3(0.1, 0.18, 0.12), Vector3(0, head_y + head_size.y * 0.5 + 0.08, head_z), Color(0.9, 0.2, 0.2))
		"vaca":
			_part(Vector3(0.3, 0.2, 0.15), Vector3(0, head_y - 0.1, head_z - head_size.z * 0.5), Color(0.95, 0.7, 0.7))
			_part(Vector3(0.12, 0.25, 0.1), Vector3(-0.2, head_y + head_size.y * 0.5, head_z), dark)
			_part(Vector3(0.12, 0.25, 0.1), Vector3(0.2, head_y + head_size.y * 0.5, head_z), dark)
		"perro", "gato":
			_part(Vector3(0.12, 0.2, 0.1), Vector3(-0.12, head_y + head_size.y * 0.5 + 0.05, head_z), dark)
			_part(Vector3(0.12, 0.2, 0.1), Vector3(0.12, head_y + head_size.y * 0.5 + 0.05, head_z), dark)
			_part(Vector3(0.1, 0.1, 0.1), Vector3(0, head_y, head_z - head_size.z * 0.5 - 0.02), Color(0.15, 0.12, 0.12))
		"caballo":
			_part(Vector3(0.12, 0.28, 0.1), Vector3(-0.14, head_y + head_size.y * 0.5 + 0.06, head_z), dark)
			_part(Vector3(0.12, 0.28, 0.1), Vector3(0.14, head_y + head_size.y * 0.5 + 0.06, head_z), dark)
			_part(Vector3(0.28, 0.16, 0.14), Vector3(0, head_y - 0.12, head_z - head_size.z * 0.5), dark.darkened(0.1))
		"oveja", "cabra":
			_part(Vector3(0.12, 0.2, 0.1), Vector3(-0.15, head_y + head_size.y * 0.5, head_z), dark)
			_part(Vector3(0.12, 0.2, 0.1), Vector3(0.15, head_y + head_size.y * 0.5, head_z), dark)
			if species == "cabra":
				_part(Vector3(0.08, 0.25, 0.08), Vector3(-0.08, head_y + head_size.y * 0.5 + 0.12, head_z), Color(0.85, 0.8, 0.7))
				_part(Vector3(0.08, 0.25, 0.08), Vector3(0.08, head_y + head_size.y * 0.5 + 0.12, head_z), Color(0.85, 0.8, 0.7))


func _apply_baby_scale() -> void:
	var f: float = 0.55 + 0.45 * clampf(float(age_days) / float(GROW_DAYS), 0.0, 1.0)
	scale = Vector3.ONE * f


func _physics_process(delta: float) -> void:
	hunger = maxf(0.0, hunger - delta * 0.05)
	hydration = maxf(0.0, hydration - delta * 0.06)
	if ridden:
		_ride_move(delta)
		return
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


func _ride_move(delta: float) -> void:
	# El jugador dirige con WASD; Shift galopa si hay energia (spec 022).
	var input_vec: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var dir := Vector3(input_vec.x, 0.0, input_vec.y)
	if dir.length() > 1.0:
		dir = dir.normalized()
	var spd := 6.5
	if Input.is_action_pressed("sprint"):
		for p: Node in get_tree().get_nodes_in_group("player"):
			if p.has_method("spend_energy") and bool(p.call("spend_energy", 2.0 * delta)):
				spd *= 1.3
				break
	velocity.x = dir.x * spd
	velocity.z = dir.z * spd
	velocity.y = 0.0 if is_on_floor() else velocity.y - 20.0 * delta
	move_and_slide()
	if dir.length() > 0.1:
		rotation.y = lerp_angle(rotation.y, atan2(-dir.x, -dir.z), 8.0 * delta)


func mount(player: Node) -> void:
	ridden = true
	if player != null and player.has_method("set"):
		player.set("riding", self)
		player.set("collision_layer", 0)
		player.set("collision_mask", 0)


func dismount(player: Node) -> void:
	ridden = false
	if player != null and player.has_method("set"):
		player.set("riding", null)
		player.set("collision_layer", 1)
		player.set("collision_mask", 1)
		(player as Node3D).global_position = global_position + Vector3(1.5, 0.5, 0.0)


func get_prompt() -> String:
	if data != null and data.rideable:
		return "Desmontar" if ridden else "Montar"
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
	if data != null and data.rideable:
		if ridden:
			dismount(player)
		else:
			mount(player)
		return
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
