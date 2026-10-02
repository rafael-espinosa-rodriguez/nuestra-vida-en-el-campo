extends Node
## Guardado robusto en user://savegame.json (GDD §§61, 80). Autoload "SaveSystem".
## Autosave al dormir (TimeSystem) + manual. Carga tolerante a campos ausentes.

const SAVE_PATH := "user://savegame.json"
const SAVE_VERSION := 1


func save_game() -> bool:
	var data := {
		"version": SAVE_VERSION,
		"day": _get_time_day(),
		"hour": _get_time_hour(),
		"player_pos": _player_pos(),
		"inventory": _get_inventory(),
		"plots": _get_plots(),
		"animals": _get_animals(),
		"relations": _get_relations(),
		"money": _get_money(),
		"memories": [],
	}
	var err := _write(data)
	if err:
		return true
	return false


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if f == null:
		return false
	var parsed: Variant = JSON.parse_string(f.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
	var data: Dictionary = parsed
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	if time_sys != null:
		time_sys.set("current_day", int(data.get("day", 1)))
		time_sys.set("hour", float(data.get("hour", 6.0)))
	var inv_sys: Node = get_node_or_null("/root/InventorySystem")
	if inv_sys != null and data.has("inventory") and typeof(data["inventory"]) == TYPE_DICTIONARY:
		var clean := {}
		for k: String in (data["inventory"] as Dictionary).keys():
			clean[k] = int((data["inventory"] as Dictionary)[k])
		inv_sys.set("items", clean)
	if data.has("player_pos") and typeof(data["player_pos"]) == TYPE_ARRAY:
		var a: Array = data["player_pos"]
		if a.size() == 3:
			for p: Node in get_tree().get_nodes_in_group("player"):
				if p is Node3D:
					(p as Node3D).global_position = Vector3(float(a[0]), float(a[1]), float(a[2]))
	if data.has("plots") and typeof(data["plots"]) == TYPE_ARRAY:
		var farm: Node = get_node_or_null("/root/FarmingSystem")
		if farm != null and farm.has_method("deserialize"):
			farm.deserialize(data["plots"])
	if data.has("animals") and typeof(data["animals"]) == TYPE_ARRAY:
		var herd: Node = get_node_or_null("/root/AnimalSystem")
		if herd != null and herd.has_method("deserialize"):
			herd.deserialize(data["animals"])
	if data.has("relations") and typeof(data["relations"]) == TYPE_DICTIONARY:
		var rel: Node = get_node_or_null("/root/RelationshipSystem")
		if rel != null and rel.has_method("deserialize"):
			rel.call("deserialize", data["relations"])
	if data.has("money"):
		var inv2: Node = get_node_or_null("/root/InventorySystem")
		if inv2 != null:
			inv2.set("money", int(data["money"]))
	return true


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func _write(data: Dictionary) -> bool:
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f == null:
		push_error("SaveSystem: no se pudo escribir " + SAVE_PATH)
		return false
	f.store_string(JSON.stringify(data, "  "))
	return true


func _get_time_day() -> int:
	var t: Node = get_node_or_null("/root/TimeSystem")
	return int(t.get("current_day")) if t != null else 1


func _get_time_hour() -> float:
	var t: Node = get_node_or_null("/root/TimeSystem")
	return float(t.get("hour")) if t != null else 6.0


func _get_inventory() -> Dictionary:
	var inv: Node = get_node_or_null("/root/InventorySystem")
	if inv != null and ("items" in inv):
		return (inv.get("items") as Dictionary).duplicate()
	return {}


func _get_plots() -> Array:
	var farm: Node = get_node_or_null("/root/FarmingSystem")
	if farm != null and farm.has_method("serialize"):
		return farm.serialize()
	return []


func _get_animals() -> Array:
	var herd: Node = get_node_or_null("/root/AnimalSystem")
	if herd != null and herd.has_method("serialize"):
		return herd.serialize()
	return []


func _get_relations() -> Dictionary:
	var rel: Node = get_node_or_null("/root/RelationshipSystem")
	if rel != null and rel.has_method("serialize"):
		return rel.call("serialize")
	return {}


func _get_money() -> int:
	var inv: Node = get_node_or_null("/root/InventorySystem")
	return int(inv.get("money")) if inv != null else 0


func _player_pos() -> Array:
	for p: Node in get_tree().get_nodes_in_group("player"):
		if p is Node3D:
			var v: Vector3 = (p as Node3D).global_position
			return [v.x, v.y, v.z]
	return [0.0, 0.8, 0.0]
