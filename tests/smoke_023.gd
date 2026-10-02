extends SceneTree
## Smoke spec 023: manzanas de temporada, pico/piedra/mineral, mermelada.

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
	var inv: Node = root.get_node_or_null("InventorySystem")
	var time_sys: Node = root.get_node_or_null("TimeSystem")
	var player: Node = get_nodes_in_group("player")[0]
	player.set("energy", 100.0)
	assert(player.call("equip", "pico"), "equipa pico del kit")
	var manzanos: Array[Node] = get_nodes_in_group("manzanos")
	assert(manzanos.size() == 2, "2 manzanos")
	time_sys.set("current_day", 1)
	assert(String(manzanos[0].call("get_prompt")) == "Sin fruta (verano/otoño)", "sin fruta en primavera")
	manzanos[0].call("interact", player)
	assert(int(inv.call("get_count", "manzana")) == 0, "fuera de temporada no da")
	time_sys.set("current_day", 9)
	manzanos[0].call("interact", player)
	manzanos[0].call("interact", player)
	assert(int(inv.call("get_count", "manzana")) == 2, "recoge 2 manzanas en verano")
	var piedra: Node = main.get_node("Piedra1")
	player.set("equipped_tool", "")
	var antes: int = int(inv.call("get_count", "piedra"))
	piedra.call("interact", player)
	assert(int(inv.call("get_count", "piedra")) == antes, "sin pico no pica")
	assert(player.call("equip", "pico"), "re-equipa pico")
	piedra.call("interact", player)
	assert(int(inv.call("get_count", "piedra")) == antes + 1, "pica piedra")
	assert(String(piedra.call("get_prompt")) == "Agotado (vuelve mañana)", "prompt agotado")
	var mineral: Node = main.get_node("Mineral1")
	mineral.call("interact", player)
	assert(int(inv.call("get_count", "mineral")) == 1, "pica mineral")
	inv.call("add_item", "manzana", 1)
	player.set("energy", 100.0)
	main.get_node("Conservera").call("interact", player)
	assert(int(inv.call("get_count", "mermelada")) == 1, "3 manzanas -> mermelada")
	assert(bool(player.call("eat", "mermelada")), "mermelada comestible")
	print("SMOKE023 OK")
