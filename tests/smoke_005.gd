extends SceneTree
## Smoke spec 005: alimentar, acariciar, producir y recoger; tick diario; nombres.

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
	var animals: Array[Node] = get_nodes_in_group("animals")
	assert(animals.size() >= 5, "gallinas + vaca + perro presentes")
	var names := {}
	for a: Node in animals:
		names[String(a.get("animal_name"))] = true
	for n: String in ["Misha", "Zara", "Lola", "Clara", "Toby"]:
		assert(names.has(n), "existe " + n)
	var herd: Node = root.get_node_or_null("AnimalSystem")
	var inv: Node = root.get_node_or_null("InventorySystem")
	var misha: Node = herd.call("find", "Misha")
	misha.set("hunger", 20.0)
	inv.call("add_item", "trigo", 2)
	var player: Node = get_nodes_in_group("player")[0]
	var trigo_antes: int = int(inv.call("get_count", "trigo"))
	misha.call("interact", player)
	assert(float(misha.get("hunger")) > 20.0, "E con hambre alimenta (gasta trigo)")
	assert(int(inv.call("get_count", "trigo")) == trigo_antes - 1, "alimentar consume 1 trigo")
	misha.set("hunger", 90.0)
	misha.set("pending", 2)
	misha.call("interact", player)
	assert(int(misha.get("pending")) == 1, "E con huevo recoge")
	assert(int(inv.call("get_count", "huevo")) >= 1, "huevo al inventario")
	assert(bool(herd.call("pet", "Toby")), "acariciar al perro")
	var toby: Node = herd.call("find", "Toby")
	assert(float(toby.get("affection")) > 0.0, "afecto sube")
	var h0: float = float(misha.get("hunger"))
	root.get_node_or_null("TimeSystem").emit_signal("day_changed", 2)
	assert(float(misha.get("hunger")) < h0, "tick diario baja hambre")
	assert(int(root.get_node_or_null("AnimalSystem").call("serialize").size()) >= 5, "serialize cubre animales")
	print("SMOKE005 OK")
