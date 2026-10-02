class_name Plot
extends InteractableArea3D
## Parcela de cultivo (GDD §§23-25, spec 004). Estados: sin arar -> arada -> plantada -> lista.
## Requiere agua para avanzar; la lluvia riega sola (FarmingSystem.water_all).

enum State { UNTILLED, TILED, PLANTED, READY }

# Duplicado MVP de resources/data/crops/*.tres (grow_days) para logica runtime.
const GROW_DAYS := {"trigo": 3, "zanahoria": 2, "tomate": 4, "maiz": 3, "calabaza": 4}
const SEED_FOR := {"trigo": "semilla_trigo", "zanahoria": "semilla_zanahoria", "tomate": "semilla_tomate", "maiz": "semilla_maiz", "calabaza": "semilla_calabaza"}
# Temporadas por cultivo (0 prim, 1 ver, 2 oto). El tomate, del MVP de primavera, aguanta hasta verano.
const SEASONS_FOR := {"trigo": [0], "zanahoria": [0], "tomate": [0, 1], "maiz": [1], "calabaza": [2]}

var state: int = State.UNTILLED
var crop_id: String = ""
var growth: int = 0
var watered: bool = false

var _mat_dry: StandardMaterial3D
var _mat_wet: StandardMaterial3D
var _mat_crop: StandardMaterial3D

@onready var soil: MeshInstance3D = $Soil
@onready var crop_mesh: MeshInstance3D = $Crop


func _ready() -> void:
	add_to_group("plots")
	_mat_dry = StandardMaterial3D.new()
	_mat_dry.albedo_color = Color(0.42, 0.3, 0.18)
	_mat_wet = StandardMaterial3D.new()
	_mat_wet.albedo_color = Color(0.22, 0.15, 0.09)
	_mat_crop = StandardMaterial3D.new()
	_mat_crop.albedo_color = Color(0.3, 0.7, 0.25)
	soil.set_surface_override_material(0, _mat_dry)
	crop_mesh.set_surface_override_material(0, _mat_crop)
	_refresh()


func get_prompt() -> String:
	match state:
		State.UNTILLED:
			return "Arar (azada)"
		State.TILED:
			return "Plantar semilla de temporada"
		State.PLANTED:
			return "Regar (regadera)" if not watered else "Creciendo..."
		State.READY:
			return "Cosechar"
	return prompt


func interact(player: Node) -> void:
	if player == null or not (player is Player):
		return
	var pl: Player = player as Player
	match state:
		State.UNTILLED:
			if pl.equipped_tool == "azada" and pl.spend_energy(5.0):
				till()
		State.TILED:
			plant_first_seed()
		State.PLANTED:
			if not watered and pl.equipped_tool == "regadera":
				water()
		State.READY:
			if pl.spend_energy(3.0):
				harvest()


func till() -> void:
	if state != State.UNTILLED:
		return
	state = State.TILED
	_refresh()


func in_season(crop: String) -> bool:
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	var season := 0
	if time_sys != null and time_sys.has_method("season_index"):
		season = int(time_sys.call("season_index"))
	return SEASONS_FOR.has(crop) and int(season) in SEASONS_FOR[crop]


func plant_first_seed() -> bool:
	if state != State.TILED:
		return false
	for crop: String in ["trigo", "zanahoria", "tomate", "maiz", "calabaza"]:
		if not in_season(crop):
			continue
		var seed: String = String(SEED_FOR[crop])
		if InventorySystem.has(seed):
			InventorySystem.remove_item(seed)
			crop_id = crop
			growth = 0
			watered = false
			state = State.PLANTED
			_refresh()
			return true
	return false


func plant(crop: String) -> bool:
	if state != State.TILED or not GROW_DAYS.has(crop):
		return false
	if not in_season(crop):
		return false
	var seed: String = String(SEED_FOR[crop])
	if not InventorySystem.has(seed):
		return false
	InventorySystem.remove_item(seed)
	crop_id = crop
	growth = 0
	watered = false
	state = State.PLANTED
	_refresh()
	return true


func water() -> void:
	if state != State.PLANTED:
		return
	watered = true
	_refresh()


func new_day() -> void:
	if state != State.PLANTED:
		return
	if watered:
		growth += 1
		if growth >= int(GROW_DAYS.get(crop_id, 99)):
			state = State.READY
	watered = false
	_refresh()


func harvest() -> String:
	if state != State.READY:
		return ""
	state = State.TILED
	var got := crop_id
	crop_id = ""
	growth = 0
	watered = false
	_refresh()
	InventorySystem.add_item(got)
	return got


func serialize() -> Dictionary:
	return {"name": name, "state": state, "crop": crop_id, "growth": growth, "watered": watered}


func deserialize(d: Dictionary) -> void:
	state = int(d.get("state", State.UNTILLED))
	crop_id = String(d.get("crop", ""))
	growth = int(d.get("growth", 0))
	watered = bool(d.get("watered", false))
	_refresh()


func _refresh() -> void:
	if not is_node_ready():
		return
	soil.set_surface_override_material(0, _mat_wet if watered or state == State.TILED else _mat_dry)
	if state == State.PLANTED or state == State.READY:
		var days: float = float(GROW_DAYS.get(crop_id, 1))
		var f: float = clampf(float(growth) / days, 0.15, 1.0)
		if state == State.READY:
			f = 1.0
			_mat_crop.albedo_color = Color(0.85, 0.75, 0.3)
		crop_mesh.visible = true
		crop_mesh.scale = Vector3(f, f, f)
	else:
		crop_mesh.visible = false
