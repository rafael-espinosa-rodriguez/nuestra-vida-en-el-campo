extends SceneTree
## Smoke spec 019: criar con 2 adultos felices, bebe crece en 3 dias y produce.

var _frames := 0


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames == 5:
		_run()
		quit()
	return false


func _run() -> void:
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	var herd: Node = root.get_node_or_null("AnimalSystem")
	var inv: Node = root.get_node_or_null("InventorySystem")
	var time_sys: Node = root.get_node_or_null("TimeSystem")
	var corral: Node = main.get_node("Corral")
	inv.call("add_item", "trigo", 2)
	for a: Node in get_nodes_in_group("animals"):
		if a.get("data") != null and String(a.get("data").get("species")) == "gallina":
			a.set("happiness", 80.0)
			a.set("hunger", 90.0)
	corral.call("interact", null)
	var names := []
	for a: Node in get_nodes_in_group("animals"):
		names.append(String(a.get("animal_name")))
	assert(names.size() == 11, "nace 1 cria (10+1)")
	var baby: Node = null
	for a: Node in get_nodes_in_group("animals"):
		if bool(a.get("is_baby")):
			baby = a
	assert(baby != null, "la cria es bebe")
	assert(int(baby.get("pending")) == 0, "bebe no produce")
	assert(String(herd.call("breed", "vaca")) == "", "vacas: solo Clara, sin cria")
	for day: int in [2, 3, 4]:
		for a: Node in get_nodes_in_group("animals"):
			herd.call("feed", String(a.get("animal_name")))
		time_sys.emit_signal("day_changed", day)
	assert(bool(baby.get("is_baby")) == false, "crece en 3 dias")
	herd.call("feed", String(baby.get("animal_name")))
	baby.set("hydration", 90.0)
	time_sys.emit_signal("day_changed", 5)
	assert(int(baby.get("pending")) >= 1, "adulta produce")
	assert(int(herd.call("serialize").size()) == 11, "serialize cubre 11")
	print("SMOKE019 OK")
