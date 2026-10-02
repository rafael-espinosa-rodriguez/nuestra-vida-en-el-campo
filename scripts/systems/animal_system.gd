extends Node
## Sistema UNICO para todas las especies (principio GDD §78). Autoload "AnimalSystem".
## Los animales son datos (AnimalData), no sistemas. Tick diario via day_changed.


func _ready() -> void:
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	if time_sys != null:
		time_sys.connect("day_changed", on_new_day)


func on_new_day(_day: int) -> void:
	for a: Node in get_tree().get_nodes_in_group("animals"):
		if a.has_method("new_day"):
			a.call("new_day")


func find(animal_name: String) -> Node:
	for a: Node in get_tree().get_nodes_in_group("animals"):
		if String(a.get("animal_name")) == animal_name:
			return a
	return null


func feed(animal_name: String, _food_id: String = "") -> bool:
	var a := find(animal_name)
	if a == null:
		return false
	a.call("feed")
	return true


func pet(animal_name: String) -> bool:
	var a := find(animal_name)
	if a == null:
		return false
	a.call("pet")
	return true


func collect(animal_name: String) -> String:
	var a := find(animal_name)
	if a == null:
		return ""
	return String(a.call("collect"))


func serialize() -> Array:
	var out := []
	for a: Node in get_tree().get_nodes_in_group("animals"):
		if a.has_method("serialize"):
			out.append(a.call("serialize"))
	return out


func deserialize(arr: Array) -> void:
	var by_name := {}
	for a: Node in get_tree().get_nodes_in_group("animals"):
		by_name[String(a.get("animal_name"))] = a
	for d: Variant in arr:
		if typeof(d) == TYPE_DICTIONARY and by_name.has(String(d.get("name", ""))):
			by_name[String(d.get("name", ""))].call("deserialize", d)
