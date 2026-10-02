extends SceneTree
## Smoke spec 025: 6 vecinos, reunion en festival, lineas de fiesta, confeti.

var _frames := 0
var _main: Node


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames == 5:
		_phase_one()
	if _frames == 8:
		_phase_two()
		quit()
	return false


func _phase_one() -> void:
	_main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(_main)
	var npcs: Array[Node] = get_nodes_in_group("npcs")
	assert(npcs.size() == 6, "6 vecinos")
	var names := {}
	for n: Node in npcs:
		names[String(n.get("npc_name"))] = n
	for k: String in ["Mara", "Bram", "Nara", "Sari", "Lupo", "Aina"]:
		assert(names.has(k), "existe " + k)
	var time_sys: Node = root.get_node_or_null("TimeSystem")
	time_sys.set("current_day", 7)
	time_sys.set("hour", 12.0)
	assert(bool(time_sys.call("is_festival_day")), "D7 festival")


func _phase_two() -> void:
	var time_sys: Node = root.get_node_or_null("TimeSystem")
	assert(bool(time_sys.call("is_festival_day")), "sigue festival")
	for n: Node in get_nodes_in_group("npcs"):
		if String(n.get("npc_name")) == "Lupo":
			continue
		n.call("update_schedule")
		var target: Vector3 = n.get("_target")
		var plaza: Vector3 = n.get("plaza_pos")
		assert(target.distance_to(plaza) < 0.1, String(n.get("npc_name")) + " va a la plaza")
	var aina: Node = null
	for n: Node in get_nodes_in_group("npcs"):
		if String(n.get("npc_name")) == "Aina":
			aina = n
	var line: String = String(aina.call("talk"))
	assert(line.contains("fiesta"), "linea de fiesta")
	assert(bool(_main.get_node("Village/Confetti").visible), "confeti visible")
	print("SMOKE025 OK")
