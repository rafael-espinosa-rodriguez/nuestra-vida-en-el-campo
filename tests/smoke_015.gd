extends SceneTree
## Smoke spec 015: temporadas, bloqueo fuera de temporada, clima por estacion, tinte.

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
	assert(String(time_sys.call("season_name")) == "primavera", "D1 primavera")
	assert(int(time_sys.call("season_index")) == 0, "idx 0")
	time_sys.set("current_day", 8)
	assert(String(time_sys.call("season_name")) == "verano", "D8 verano")
	assert(int(time_sys.call("day_in_season")) == 1, "dia 1 de verano")
	time_sys.set("current_day", 15)
	assert(String(time_sys.call("season_name")) == "otoño", "D15 otoño")
	time_sys.set("current_day", 22)
	assert(String(time_sys.call("season_name")) == "invierno", "D22 invierno")
	time_sys.set("current_day", 1)
	var plots: Array[Node] = get_nodes_in_group("plots")
	plots[0].call("till")
	inv.call("add_item", "semilla_maiz", 1)
	assert(bool(plots[0].call("plant", "maiz")) == false, "maiz bloqueado en primavera")
	assert(bool(plots[0].call("plant", "trigo")), "trigo ok en primavera")
	time_sys.set("current_day", 8)
	plots[1].call("till")
	assert(bool(plots[1].call("plant", "trigo")) == false, "trigo bloqueado en verano")
	assert(bool(plots[1].call("plant", "maiz")), "maiz ok en verano")
	weather.call("roll_daily_weather", 6)
	assert(int(weather.get("current")) == 2, "primavera D6 llueve")
	weather.call("roll_daily_weather", 13)
	assert(int(weather.get("current")) == 2, "verano dia 6 llueve")
	weather.call("roll_daily_weather", 16)
	assert(int(weather.get("current")) == 2, "otoño dia 2 llueve")
	time_sys.set("current_day", 15)
	time_sys.set("hour", 12.0)


func _phase_two() -> void:
	var soil_mat: Material = _main.get_node("Ground/GroundMesh").get_surface_override_material(0)
	assert(soil_mat != null, "tinte de temporada aplicado")
	print("SMOKE015 OK")
