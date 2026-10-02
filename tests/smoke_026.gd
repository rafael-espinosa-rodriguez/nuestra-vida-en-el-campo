extends SceneTree
## Smoke spec 026: titulo (nueva/continuar), pausa, tonos sfx, balanceo.

var _frames := 0


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames == 5:
		_run()
		quit()
	return false


func _run() -> void:
	var audio: Node = root.get_node_or_null("AudioSystem")
	var tone: AudioStreamWAV = audio.call("make_tone", 440.0, 0.1)
	assert(tone != null and tone.data.size() > 1000, "tono procedural generado")
	audio.call("sfx", "pickup")
	var title: Control = load("res://scenes/Title.tscn").instantiate()
	root.add_child(title)
	assert(title.get_node("Center/Menu/NewButton") is Button, "boton nueva")
	assert(title.get_node("Center/Menu/ContinueButton") is Button, "boton continuar")
	assert(title.get_node("Center/Menu/QuitButton") is Button, "boton salir")
	var save_sys: Node = root.get_node_or_null("SaveSystem")
	var time_sys: Node = root.get_node_or_null("TimeSystem")
	time_sys.set("current_day", 42)
	title.call("new_game")
	assert(int(time_sys.get("current_day")) == 1, "nueva partida resetea dia")
	root.remove_child(title)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	var hud: Node = get_nodes_in_group("hud")[0]
	assert(bool(paused) == false, "empieza sin pausa")
	hud.call("toggle_pause")
	assert(bool(paused), "pausa activa")
	assert(bool(hud.get_node("PausePanel").visible), "panel pausa visible")
	hud.call("toggle_pause")
	assert(bool(paused) == false, "reanuda")
	print("SMOKE026 OK")
