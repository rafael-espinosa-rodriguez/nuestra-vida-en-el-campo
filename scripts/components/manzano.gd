class_name Manzano
extends InteractableArea3D
## Manzano con 3 manzanas que rebrotan a diario en verano/otoño (spec 023).

var apples: int = 3

@onready var apple_meshes: Array[MeshInstance3D] = [$Manzana1, $Manzana2, $Manzana3]


func _ready() -> void:
	add_to_group("manzanos")
	_refresh()
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	if time_sys != null:
		time_sys.connect("day_changed", _on_new_day)


func in_season() -> bool:
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	if time_sys == null or not time_sys.has_method("season_index"):
		return true
	return int(time_sys.call("season_index")) in [1, 2]


func get_prompt() -> String:
	if not in_season():
		return "Sin fruta (verano/otoño)"
	if apples <= 0:
		return "Sin manzanas (vuelve mañana)"
	return "Recoger manzana"


func interact(player: Node) -> void:
	if apples <= 0 or not in_season():
		return
	if player != null and player is Player and not (player as Player).spend_energy(2.0):
		return
	apples -= 1
	_refresh()
	var inv: Node = get_node_or_null("/root/InventorySystem")
	if inv != null:
		inv.call("add_item", "manzana")


func _on_new_day(_day: int) -> void:
	if in_season():
		apples = 3
		_refresh()


func _refresh() -> void:
	if not is_node_ready():
		return
	for i: int in apple_meshes.size():
		apple_meshes[i].visible = i < apples and in_season()
