extends SceneTree
## Smoke spec 021: queso, yogur y encurtido con sus estaciones.

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
	var player: Node = get_nodes_in_group("player")[0]
	player.set("energy", 100.0)
	inv.call("add_item", "leche", 3)
	main.get_node("Quesera").call("interact", player)
	assert(int(inv.call("get_count", "queso")) == 1, "2 leche -> queso")
	main.get_node("Quesera").call("interact", player)
	assert(int(inv.call("get_count", "yogur")) == 1, "1 leche -> yogur")
	assert(int(inv.call("get_count", "leche")) == 0, "leche consumida")
	inv.call("add_item", "zanahoria", 1)
	inv.call("add_item", "tomate", 1)
	main.get_node("Conservera").call("interact", player)
	assert(int(inv.call("get_count", "encurtido")) == 1, "verdura -> encurtido")
	assert(bool(player.call("eat", "queso")), "queso comestible")
	assert(bool(player.call("eat", "encurtido")), "encurtido comestible")
	var market: Node = root.get_node_or_null("MarketSystem")
	inv.call("add_item", "huevo", 3)
	assert(int(market.call("surplus_value")) == 3, "excedente cotiza")
	print("SMOKE021 OK")
