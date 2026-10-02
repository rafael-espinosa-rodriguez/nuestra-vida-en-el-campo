extends SceneTree
## Smoke spec 016: invierno congela el huerto, nieve visible, calor de chimenea.

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
	var time_sys: Node = root.get_node_or_null("TimeSystem")
	var weather: Node = root.get_node_or_null("WeatherSystem")
	var inv: Node = root.get_node_or_null("InventorySystem")
	var player: Node = get_nodes_in_group("player")[0]
	time_sys.set("current_day", 22)
	assert(String(time_sys.call("season_name")) == "invierno", "D22 invierno")
	weather.call("roll_daily_weather", 23)
	assert(int(weather.get("current")) == 3, "nieve en invierno")
	weather.call("roll_daily_weather", 22)
	assert(int(weather.get("current")) == 1, "dia 1 de invierno nublado")
	var plots: Array[Node] = get_nodes_in_group("plots")
	time_sys.set("current_day", 1)
	plots[0].call("till")
	assert(bool(plots[0].call("plant", "trigo")), "siembra control en primavera")
	plots[0].call("water")
	time_sys.set("current_day", 22)
	plots[0].call("new_day")
	assert(int(plots[0].get("growth")) == 0, "huerto congelado: no crece")
	inv.call("add_item", "madera", 1)
	var fire: Node = _main.get_node("Fireplace")
	fire.call("interact", player)
	assert(bool(fire.get("lit")), "chimenea encendida")
	player.set("energy", 50.0)
	player.set("global_position", Vector3(-2, 0.8, -6.6))
	time_sys.set("hour", 12.0)


func _phase_two() -> void:
	var player: Node = get_nodes_in_group("player")[0]
	assert(float(player.get("energy")) > 50.0, "aura de calor restaura energia")
	assert(bool(_main.get_node("Snow").visible), "nieve visible en invierno")
	var sign: Node = _main.get_node("WinterSign")
	assert(String(sign.call("get_prompt")).contains("huerto"), "cartel de preparacion")
	print("SMOKE016 OK")
