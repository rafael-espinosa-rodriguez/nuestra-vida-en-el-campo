extends SceneTree
## Smoke spec 007: talar arbol, tabla semanal de clima, audio sin archivos no rompe.

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
	var trees: Array[Node] = get_nodes_in_group("trees")
	assert(trees.size() >= 8, "bosque con 8+ arboles")
	var inv: Node = root.get_node_or_null("InventorySystem")
	var player: Node = get_nodes_in_group("player")[0]
	inv.call("add_item", "hacha")
	assert(player.call("equip", "hacha"), "equipa hacha")
	player.set("energy", 100.0)
	trees[0].call("interact", player)
	assert(bool(trees[0].get("felled")), "talar derriba el arbol")
	assert(int(inv.call("get_count", "madera")) >= 2, "talar da 2 madera")
	assert(float(player.get("energy")) < 100.0, "talar consume energia")
	var weather: Node = root.get_node_or_null("WeatherSystem")
	var expected := {1: 0, 2: 0, 3: 1, 4: 0, 5: 1, 6: 2, 7: 0}
	for day: int in expected.keys():
		weather.call("roll_daily_weather", day)
		assert(int(weather.get("current")) == int(expected[day]), "clima D%d" % day)
	var audio: Node = root.get_node_or_null("AudioSystem")
	assert(audio.call("play_ambience", "lluvia") == false, "sin .ogg no rompe, avisa")
	assert(audio.call("play_ambience", "inexistente") == false, "id desconocido no rompe")
	print("SMOKE007 OK")
