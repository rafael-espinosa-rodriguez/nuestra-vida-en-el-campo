extends SceneTree
## Smoke spec 004: arar/plantar/regar con jugador, tick diario, cosecha, lluvia riega.

var _frames := 0
var _time: Node
var _weather: Node
var _inv: Node


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames == 5:
		_run()
		quit()
	return false


func _new_day(n: int) -> void:
	# Replica TimeSystem._change_day: primero clima, luego tick.
	_weather.call("roll_daily_weather", n)
	_time.set("current_day", n)
	_time.emit_signal("day_changed", n)


func _run() -> void:
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	var plots: Array[Node] = get_nodes_in_group("plots")
	assert(plots.size() == 6, "6 parcelas en Main")
	_time = root.get_node_or_null("TimeSystem")
	_weather = root.get_node_or_null("WeatherSystem")
	_inv = root.get_node_or_null("InventorySystem")
	var player: Node = get_nodes_in_group("player")[0]
	assert(player.call("equip", "azada"), "equipa azada")
	plots[0].interact(player)
	assert(int(plots[0].get("state")) == 1, "E+azada ara la parcela")
	assert(player.call("equip", "regadera"), "equipa regadera")
	assert(bool(plots[0].call("plant", "trigo")), "planta trigo con semilla del kit")
	# Trigo: 3 dias regados.
	plots[0].call("water")
	_new_day(2)
	plots[0].call("water")
	_new_day(3)
	plots[0].call("water")
	_new_day(4)
	assert(int(plots[0].get("state")) == 3, "trigo listo en 3 dias regados")
	plots[0].interact(player)
	assert(int(plots[0].get("state")) == 1, "cosechar deja arada")
	assert(int(_inv.call("get_count", "trigo")) >= 1, "cosecha suma trigo")
	# Zanahoria: 2 dias; D6 llueve y riega sola.
	assert(player.call("equip", "azada"), "re-equipa azada")
	plots[1].interact(player)
	assert(bool(plots[1].call("plant", "zanahoria")), "planta zanahoria")
	plots[1].call("water")
	_new_day(5)
	assert(int(plots[1].get("state")) == 2, "dia 5 sigue creciendo")
	assert(int(_weather.get("current")) != 2, "D5 no llueve")
	# D6 NO se riega a mano: la lluvia debe hacerlo.
	_new_day(6)
	assert(int(_weather.get("current")) == 2, "D6 llueve")
	assert(int(plots[1].get("state")) == 3, "D6 lluvia riega sola y completa la zanahoria")
	_new_day(7)
	assert(int(plots[1].get("state")) == 3, "lista se mantiene")
	print("SMOKE004 OK")
