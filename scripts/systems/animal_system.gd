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


func breed(species_id: String) -> String:
	# Dos adultos felices de la misma especie + 2 trigo -> cria (GDD §21).
	var adults := []
	for a: Node in get_tree().get_nodes_in_group("animals"):
		if a.get("data") != null and String(a.get("data").get("species")) == species_id and not bool(a.get("is_baby")):
			adults.append(a)
	if adults.size() < 2:
		return ""
	var happy := 0.0
	for a: Node in adults:
		happy += float(a.get("happiness"))
	if happy / float(adults.size()) < 50.0:
		return ""
	if get_tree().get_nodes_in_group("animals").size() >= 12:
		return ""
	var inv: Node = get_node_or_null("/root/InventorySystem")
	if inv == null or int(inv.call("get_count", "trigo")) < 2:
		return ""
	inv.call("remove_item", "trigo", 2)
	var data: Resource = adults[0].get("data")
	var baby: Node = (load("res://scenes/Animal.tscn") as PackedScene).instantiate()
	baby.set("data", data)
	baby.set("animal_name", "Bebe_" + species_id + "_" + str(adults.size() + get_tree().get_nodes_in_group("animals").size()))
	var traits: Array = Array(data.get("personalities"))
	baby.set("personality", String(traits[randi() % traits.size()]))
	baby.set("is_baby", true)
	baby.set("hunger", 90.0)
	baby.set("hydration", 90.0)
	var anchor: Vector3 = (adults[0] as Node3D).global_position
	var home: Node = get_tree().current_scene
	if home == null:
		home = (adults[0] as Node).get_parent()
	home.add_child(baby)
	baby.set("global_position", anchor + Vector3(1.0, 0.6, 1.0))
	return String(baby.get("animal_name"))


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
