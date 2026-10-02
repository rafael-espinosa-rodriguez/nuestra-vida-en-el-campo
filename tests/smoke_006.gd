extends SceneTree
## Smoke spec 006: molino, pozo, horno (pan), comer, cama+energia, chimenea.

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
	player.set("energy", 60.0)
	inv.call("add_item", "trigo", 3)
	main.get_node("Mill").call("interact", player)
	main.get_node("Mill").call("interact", player)
	assert(int(inv.call("get_count", "harina")) == 2, "molino: 2 trigo -> 2 harina")
	main.get_node("Well").call("interact", player)
	assert(int(inv.call("get_count", "agua")) == 1, "pozo da agua")
	main.get_node("Oven").call("interact", player)
	assert(int(inv.call("get_count", "pan")) == 1, "horno cocina pan (2 harina + agua)")
	var e_before: float = float(player.get("energy"))
	assert(bool(player.call("eat", "pan")), "come pan")
	assert(float(player.get("energy")) > e_before, "comer restaura energia")
	assert(int(inv.call("get_count", "pan")) == 0, "comer consume el pan")
	inv.call("add_item", "madera", 1)
	main.get_node("Fireplace").call("interact", player)
	assert(bool(main.get_node("Fireplace").get("lit")), "chimenea enciende con madera")
	time_sys.set("hour", 22.0)
	var day0: int = int(time_sys.get("current_day"))
	player.set("energy", 20.0)
	main.get_node("Bed").call("interact", player)
	assert(int(time_sys.get("current_day")) == day0 + 1, "cama avanza al dia siguiente")
	assert(float(player.get("energy")) == 100.0, "dormir restaura energia")
	print("SMOKE006 OK")
