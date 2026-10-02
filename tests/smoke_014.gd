extends SceneTree
## Smoke spec 014: ovejas dan lana, cabra da leche, telar teje tela.

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
	assert(animals.size() == 9, "5 MVP + 2 ovejas + 1 cabra + 1 gato")
	var herd: Node = root.get_node_or_null("AnimalSystem")
	var inv: Node = root.get_node_or_null("InventorySystem")
	var time_sys: Node = root.get_node_or_null("TimeSystem")
	var player: Node = get_nodes_in_group("player")[0]
	player.set("energy", 100.0)
	var nube: Node = herd.call("find", "Nube")
	assert(nube != null, "existe Nube")
	herd.call("feed", "Nube")
	herd.call("feed", "Pepa")
	time_sys.emit_signal("day_changed", 2)
	nube.set("hunger", 90.0)
	nube.set("pending", 1)
	nube.call("interact", player)
	assert(int(inv.call("get_count", "lana")) >= 1, "oveja da lana")
	var pepa: Node = herd.call("find", "Pepa")
	pepa.set("hunger", 90.0)
	pepa.set("pending", 1)
	pepa.call("interact", player)
	assert(int(inv.call("get_count", "leche")) >= 1, "cabra da leche")
	var telar: Node = main.get_node("Telar")
	inv.call("add_item", "lana", 1)
	telar.call("interact", player)
	assert(int(inv.call("get_count", "tela")) == 1, "telar: 2 lana -> 1 tela")
	assert(int(inv.call("get_count", "lana")) == 0, "telar consume la lana")
	assert(int(herd.call("serialize").size()) == 9, "serialize cubre 9")
	print("SMOKE014 OK")
