extends SceneTree
## Smoke spec 010: 3 NPC con datos, rutina por hora y conversacion con lineas.

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
	var npcs: Array[Node] = get_nodes_in_group("npcs")
	assert(npcs.size() == 3, "3 vecinos")
	var by_name := {}
	for n: Node in npcs:
		by_name[String(n.get("npc_name"))] = n
	for k: String in ["Mara", "Bram", "Nara"]:
		assert(by_name.has(k), "existe " + k)
	var time_sys: Node = root.get_node_or_null("TimeSystem")
	var weather: Node = root.get_node_or_null("WeatherSystem")
	var mara: Node = by_name["Mara"]
	time_sys.set("hour", 10.0)
	weather.set("current", 0)
	mara.call("update_schedule")
	assert(String(mara.call("moment_key")) == "dia", "10:00 es momento dia")
	var work: Vector3 = mara.get("work_pos")
	assert((mara.get("_target") as Vector3).distance_to(work) < 0.1, "Mara va a la tienda de dia")
	var line: String = String(mara.call("talk"))
	assert(line.length() > 3, "conversar devuelve linea")
	time_sys.set("hour", 22.0)
	mara.call("update_schedule")
	assert((mara.get("_target") as Vector3).distance_to(mara.get("home_pos")) < 0.1, "de noche vuelve a casa")
	weather.set("current", 2)
	assert(String(mara.call("talk")).length() > 3, "linea de lluvia")
	var bram: Node = by_name["Bram"]
	assert(String(bram.get("data").get("favorite_gift")) == "madera", "Bram prefiere madera")
	print("SMOKE010 OK")
