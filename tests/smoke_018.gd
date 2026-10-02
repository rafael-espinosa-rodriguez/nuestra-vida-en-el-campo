extends SceneTree
## Smoke spec 018: decoracion comprable visible + festival (regalos x2, pack mitad).

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
	var inv: Node = root.get_node_or_null("InventorySystem")
	var rel: Node = root.get_node_or_null("RelationshipSystem")
	var market: Node = root.get_node_or_null("MarketSystem")
	var time_sys: Node = root.get_node_or_null("TimeSystem")
	var decor: Node = _main.get_node("Decor")
	assert(String(decor.call("get_prompt")).contains("Maceta"), "prompt ofrece maceta")
	decor.call("interact", null)
	assert(bool(inv.call("has", "decor_maceta")), "maceta comprada (10)")
	assert(int(inv.get("money")) == 0, "descuenta 10")
	assert(String(decor.call("get_prompt")).contains("Cuadro"), "prompt ofrece cuadro")
	decor.call("interact", null)
	assert(bool(inv.call("has", "decor_cuadro")) == false, "sin dinero no compra")
	time_sys.set("current_day", 7)
	assert(bool(time_sys.call("is_festival_day")), "D7 es festival")
	assert(int(market.call("pack_price")) == 2, "pack a mitad en festival")
	inv.call("add_item", "huevo", 1)
	assert(int(rel.call("gift", "Mara", "huevo")) == 16, "festival: favorito x2")
	time_sys.set("current_day", 6)
	inv.call("add_item", "huevo", 1)
	assert(int(market.call("pack_price")) == 5, "sin festival precio normal")


func _phase_two() -> void:
	assert(bool(_main.get_node("House/DecorMaceta").visible), "maceta visible en casa")
	print("SMOKE018 OK")
