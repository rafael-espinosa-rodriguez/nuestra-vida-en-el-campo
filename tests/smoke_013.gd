extends SceneTree
## Smoke spec 013: pescar con caña, recolectar setas, rebrote diario, pez comestible/vendible.

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
	assert(player.call("equip", "cana"), "equipa caña del kit")
	player.set("energy", 100.0)
	var spot: Node = main.get_node("FishingSpot")
	spot.call("interact", player)
	spot.call("interact", player)
	assert(int(inv.call("get_count", "pez")) == 2, "pescar da 2 peces")
	assert(float(player.get("energy")) < 100.0, "pescar consume energia")
	player.set("equipped_tool", "")
	var antes: int = int(inv.call("get_count", "pez"))
	spot.call("interact", player)
	assert(int(inv.call("get_count", "pez")) == antes, "sin caña no pesca")
	var setas: Node = main.get_node("Setas1")
	setas.call("interact", player)
	assert(int(inv.call("get_count", "seta")) == 1, "recoge seta")
	assert(bool(setas.get("depleted")), "mancha agotada")
	setas.call("interact", player)
	assert(int(inv.call("get_count", "seta")) == 1, "agotada no repite")
	time_sys.emit_signal("day_changed", 2)
	assert(bool(setas.get("depleted")) == false, "rebrota al dia siguiente")
	assert(bool(player.call("eat", "pez")), "pez comestible")
	print("SMOKE013 OK")
