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


func make_tone(freq_hz: float, duration_s: float = 0.15) -> AudioStreamWAV:
	# Tono procedural (spec 026): placeholder digno hasta tener arte sonoro real.
	var rate := 22050
	var frames := int(rate * duration_s)
	var data := PackedByteArray()
	data.resize(frames * 2)
	for i: int in frames:
		var t := float(i) / float(rate)
		var env: float = 1.0 - float(i) / float(frames)
		var s: float = sin(TAU * freq_hz * t) * env * 0.5
		var v := int(clampf(s, -1.0, 1.0) * 32767.0)
		data.encode_s16(i * 2, v)
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = rate
	stream.data = data
	return stream


func sfx(sfx_id: String) -> void:
	var freq := 440.0
	match sfx_id:
		"pickup":
			freq = 660.0
		"cook":
			freq = 523.0
		"coin":
			freq = 880.0
		"sleep":
			freq = 392.0
		"gift":
			freq = 784.0
		"error":
			freq = 160.0
	var p := AudioStreamPlayer.new()
	p.stream = make_tone(freq)
	p.finished.connect(p.queue_free)
	add_child(p)
	p.play()


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
