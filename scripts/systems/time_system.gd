extends Node
## Reloj del juego (GDD §§7-8, §39). Autoload "TimeSystem".
## Dia 06:00-06:00; dormir avanza al dia siguiente (spec 002).

signal day_changed(new_day: int)
signal time_changed(hour: float)

var current_day: int = 1
var hour: float = 6.0
var day_length_minutes: float = 20.0
var last_sleep_late: bool = false


func _process(delta: float) -> void:
	hour += delta * 24.0 / (day_length_minutes * 60.0)
	if hour >= 24.0:
		hour -= 24.0
		current_day += 1
		day_changed.emit(current_day)
	time_changed.emit(hour)
	_apply_to_scene()


func sleep_until_morning() -> void:
	# Dormir pasada la medianoche (00:00-05:00) deja cansancio (GDD §8).
	last_sleep_late = hour < 5.0
	current_day += 1
	hour = 6.0
	day_changed.emit(current_day)
	time_changed.emit(hour)
	_apply_to_scene()
	var save_sys: Node = get_node_or_null("/root/SaveSystem")
	if save_sys != null and save_sys.has_method("save_game"):
		save_sys.save_game()
	for p: Node in get_tree().get_nodes_in_group("player"):
		if p.has_method("restore_energy"):
			p.restore_energy(70.0 if last_sleep_late else 100.0)


func is_night() -> bool:
	return hour < 6.0 or hour >= 21.0


func _weather_factor() -> float:
	var weather: Node = get_node_or_null("/root/WeatherSystem")
	if weather == null or not ("current" in weather):
		return 1.0
	match int(weather.get("current")):
		1:
			return 0.7
		2:
			return 0.45
	return 1.0


func _apply_to_scene() -> void:
	var suns: Array[Node] = get_tree().get_nodes_in_group("sun")
	if suns.is_empty():
		return
	var sun: Node3D = suns[0] as Node3D
	if sun == null:
		return
	var t: float = clampf((hour - 6.0) / 15.0, 0.0, 1.0) # 06:00 -> 21:00
	var daylight: float = sin(PI * t) if t > 0.0 and t < 1.0 else 0.0
	if sun is DirectionalLight3D:
		var light: DirectionalLight3D = sun as DirectionalLight3D
		light.light_energy = (0.12 + 1.05 * daylight) * _weather_factor()
		var warm := Color(1.0, 0.55, 0.3)
		var noon := Color(1.0, 0.96, 0.9)
		if t < 0.15:
			light.light_color = warm.lerp(noon, t / 0.15)
		elif t > 0.8:
			light.light_color = noon.lerp(warm, (t - 0.8) / 0.2)
		else:
			light.light_color = noon
	sun.rotation_degrees = Vector3(lerpf(-8.0, -172.0, t), -35.0, 0.0)
