extends SceneTree
## Smoke spec 011: regalos (favorito/ normal / tope), niveles, trueque, guardado.

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
	var rel: Node = root.get_node_or_null("RelationshipSystem")
	var inv: Node = root.get_node_or_null("InventorySystem")
	var time_sys: Node = root.get_node_or_null("TimeSystem")
	assert(rel != null, "autoload relaciones")
	assert(int(rel.call("get_points", "Mara")) == 0, "empieza en 0")
	assert(int(rel.call("level_of", "Mara")) == 0, "nivel desconocido")
	inv.call("add_item", "huevo", 3)
	assert(int(rel.call("gift", "Mara", "huevo")) == 8, "favorito +8")
	assert(int(rel.call("gift", "Mara", "huevo")) == 8, "segundo +8")
	assert(int(rel.call("gift", "Mara", "huevo")) == 0, "tercero topado (anti-grind)")
	time_sys.emit_signal("day_changed", 2)
	assert(int(rel.call("gift", "Mara", "huevo")) == 8, "nuevo dia resetea tope")
	assert(int(rel.call("level_of", "Mara")) == 1, "24 pts = conocido")
	inv.call("add_item", "pan", 1)
	assert(int(rel.call("gift", "Bram", "pan")) == 3, "no favorito +3")
	assert(int(rel.call("gift", "Bram", "piedra_lunar")) == -1, "sin item = -1")
	inv.call("add_item", "huevo", 5)
	var trigo_antes: int = int(inv.call("get_count", "trigo"))
	assert(String(rel.call("trade_with", "Mara")) == "trigo", "trueque da trigo")
	assert(int(inv.call("get_count", "trigo")) == trigo_antes + 2, "trueque suma 2 trigo")
	assert(int(inv.call("get_count", "huevo")) == 0, "trueque descuenta 5 huevos")
	assert(String(rel.call("trade_with", "Mara")) == "", "sin huevos no hay trueque")
	var save_sys: Node = root.get_node_or_null("SaveSystem")
	assert(bool(save_sys.call("save_game")), "guarda con relaciones")
	rel.set("points", {})
	assert(bool(save_sys.call("load_game")), "carga")
	assert(int(rel.call("get_points", "Mara")) >= 20, "carga restaura puntos")
	print("SMOKE011 OK")
