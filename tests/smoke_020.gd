extends SceneTree
## Smoke spec 020: gato come pescado, enfermedad por hambre, veterinaria cura, modelos con partes.

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
	var player: Node = get_nodes_in_group("player")[0]
	var mishi: Node = herd.call("find", "Mishi")
	assert(mishi != null, "existe Mishi")
	mishi.set("hunger", 20.0)
	inv.call("add_item", "pez", 1)
	mishi.call("interact", player)
	assert(float(mishi.get("hunger")) > 20.0, "gato come pescado")
	var parts := 0
	for child: Node in mishi.get_children():
		if child is MeshInstance3D:
			parts += 1
	assert(parts >= 6, "modelo con cabeza, patas, orejas y cola")
	var clara: Node = herd.call("find", "Clara")
	clara.set("hunger", 0.0)
	time_sys.emit_signal("day_changed", 2)
	assert(bool(clara.get("sick")), "hambre cero enferma")
	assert(int(herd.call("sick_count")) >= 1, "conteo enfermos")
	var sari: Node = null
	for n: Node in get_nodes_in_group("npcs"):
		if String(n.get("npc_name")) == "Sari":
			sari = n
	assert(sari != null, "existe Sari")
	assert(String(sari.call("get_prompt")).contains("Curar"), "prompt veterinaria")
	inv.set("money", 3)
	sari.call("interact", player)
	assert(bool(clara.get("sick")), "sin monedas no cura")
	inv.set("money", 10)
	sari.call("interact", player)
	assert(bool(clara.get("sick")) == false, "veterinaria cura")
	assert(int(inv.get("money")) == 5, "cura cuesta 5")
	print("SMOKE020 OK")
