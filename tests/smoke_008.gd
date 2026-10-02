extends SceneTree
## Smoke spec 008 (integradora): semana completa D1-D7 del MVP.
## D1 llegada, D2 huevo, D3 plantar, D4 leche, D5 pan, D6 lluvia+cosecha+sopa+chimenea, D7 guardar/cargar.

var _frames := 0
var _time: Node
var _weather: Node
var _inv: Node
var _herd: Node
var _main: Node
var _player: Node


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames == 5:
		_run()
		quit()
	return false


func _new_day(n: int) -> void:
	_player.set("energy", 100.0)
	for a: Node in get_nodes_in_group("animals"):
		_herd.call("feed", String(a.get("animal_name")))
	_water_all()
	_weather.call("roll_daily_weather", n)
	_time.set("current_day", n)
	_time.emit_signal("day_changed", n)


func _water_all() -> void:
	for plot: Node in get_nodes_in_group("plots"):
		if int(plot.get("state")) == 2:
			plot.call("water")


func _plots() -> Array[Node]:
	return get_nodes_in_group("plots")


func _run() -> void:
	_main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(_main)
	_time = root.get_node_or_null("TimeSystem")
	_weather = root.get_node_or_null("WeatherSystem")
	_inv = root.get_node_or_null("InventorySystem")
	_herd = root.get_node_or_null("AnimalSystem")
	_player = get_nodes_in_group("player")[0]
	# D1 Llegada: kit, casa, animales, energia llena.
	assert(int(_inv.call("get_count", "azada")) >= 1, "D1 kit")
	assert(get_nodes_in_group("animals").size() == 5, "D1 5 animales")
	assert(get_nodes_in_group("plots").size() == 6, "D1 6 parcelas")
	assert(_main.get_node_or_null("Bed") != null, "D1 hay cama")
	assert(_main.get_node_or_null("Fireplace") != null, "D1 hay chimenea")
	# D2 Primer huevo.
	_new_day(2)
	_herd.call("feed", "Misha")
	var misha: Node = _herd.call("find", "Misha")
	misha.set("hunger", 90.0)
	misha.set("pending", 1)
	misha.call("interact", _player)
	assert(int(_inv.call("get_count", "huevo")) >= 1, "D2 primer huevo")
	# D3 Preparar y plantar.
	_player.call("equip", "azada")
	for i: int in [0, 1, 2, 3]:
		_plots()[i].call("till")
	assert(bool(_plots()[0].call("plant", "trigo")), "D3 planta trigo")
	assert(bool(_plots()[1].call("plant", "zanahoria")), "D3 planta zanahoria")
	assert(bool(_plots()[2].call("plant", "zanahoria")), "D3 planta zanahoria x2")
	assert(bool(_plots()[3].call("plant", "tomate")), "D3 planta tomate")
	_new_day(3)
	# D4 Ordeñar.
	_new_day(4)
	var clara: Node = _herd.call("find", "Clara")
	clara.set("hunger", 90.0)
	clara.set("pending", 1)
	clara.call("interact", _player)
	assert(int(_inv.call("get_count", "leche")) >= 1, "D4 leche")
	# D5 Cocinar pan + cosechar zanahoria.
	_new_day(5)
	_plots()[1].call("interact", _player)
	_plots()[2].call("interact", _player)
	assert(int(_inv.call("get_count", "zanahoria")) >= 2, "D5 cosecha 2 zanahorias")
	_main.get_node("Mill").call("interact", _player)
	_main.get_node("Mill").call("interact", _player)
	_main.get_node("Well").call("interact", _player)
	_main.get_node("Oven").call("interact", _player)
	assert(int(_inv.call("get_count", "pan")) >= 1, "D5 pan")
	# D6 Lluvia, cosecha trigo+tomate, sopa, chimenea, dormir.
	_new_day(6)
	assert(int(_weather.get("current")) == 2, "D6 llueve")
	_plots()[0].call("interact", _player)
	_plots()[3].call("interact", _player)
	assert(int(_inv.call("get_count", "trigo")) >= 1, "D6 cosecha trigo")
	assert(int(_inv.call("get_count", "tomate")) >= 1, "D6 cosecha tomate")
	_main.get_node("Well").call("interact", _player)
	_main.get_node("Oven").call("interact", _player)
	assert(int(_inv.call("get_count", "sopa")) >= 1, "D6 sopa")
	_inv.call("add_item", "madera", 1)
	_main.get_node("Fireplace").call("interact", _player)
	assert(bool(_main.get_node("Fireplace").get("lit")), "D6 chimenea")
	_time.set("hour", 22.0)
	_player.set("energy", 30.0)
	_main.get_node("Bed").call("interact", _player)
	assert(int(_time.get("current_day")) == 7, "D7 tras dormir")
	# D7 Guardar/cargar íntegro.
	var save_sys: Node = root.get_node_or_null("SaveSystem")
	assert(bool(save_sys.call("save_game")), "D7 guarda")
	var pan_antes: int = int(_inv.call("get_count", "pan"))
	_inv.call("add_item", "pan", 50)
	_time.set("hour", 20.0)
	assert(bool(save_sys.call("load_game")), "D7 carga")
	assert(int(_time.get("current_day")) == 7 and float(_time.get("hour")) == 6.0, "D7 restaura dia/hora")
	assert(int(_inv.call("get_count", "pan")) == pan_antes, "D7 restaura inventario")
	print("SMOKE008 OK: semana completa jugable")
