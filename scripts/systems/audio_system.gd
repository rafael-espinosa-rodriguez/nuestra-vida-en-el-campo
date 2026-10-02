extends Node
## Paisaje sonoro sin musica constante (GDD §37). Autoload "AudioSystem".
## Sin archivos en assets/audio/, los players quedan listos y se avisa por log.
## El clima conmuta ambiente: lluvia <-> resto.

const AUDIO_DIR := "res://assets/audio"

var _players: Dictionary = {}
var _current: String = ""


func _ready() -> void:
	for amb_id: String in ["viento", "lluvia", "fuego", "rio", "grillos", "dia"]:
		var p := AudioStreamPlayer.new()
		p.name = amb_id
		add_child(p)
		_players[amb_id] = p
	var weather: Node = get_node_or_null("/root/WeatherSystem")
	if weather != null and weather.has_signal("weather_changed"):
		weather.connect("weather_changed", _on_weather_changed)


func play_ambience(ambience_id: String) -> bool:
	if not _players.has(ambience_id):
		return false
	var path := AUDIO_DIR + "/" + ambience_id + ".ogg"
	if not FileAccess.file_exists(path):
		print("AudioSystem: sin archivo ", path, " (pendiente de arte sonoro)")
		return false
	var stream: AudioStream = load(path)
	if stream == null:
		return false
	_stop_all()
	(_players[ambience_id] as AudioStreamPlayer).stream = stream
	(_players[ambience_id] as AudioStreamPlayer).play()
	_current = ambience_id
	return true


func play_music(moment_id: String) -> bool:
	return play_ambience("musica_" + moment_id)


func stop_all() -> void:
	_stop_all()
	_current = ""


func current_id() -> String:
	return _current


func _stop_all() -> void:
	for p: AudioStreamPlayer in _players.values():
		p.stop()


func _on_weather_changed(new_weather: int) -> void:
	if new_weather == 2:
		play_ambience("lluvia")
	else:
		play_ambience("dia")
