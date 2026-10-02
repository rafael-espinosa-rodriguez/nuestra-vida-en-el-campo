extends SceneTree
## Smoke spec 012: vender excedente con reserva, comprar pack semillas, dinero en save/load.

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
	var market: Node = root.get_node_or_null("MarketSystem")
	var inv: Node = root.get_node_or_null("InventorySystem")
	assert(market != null, "autoload mercado")
	assert(int(inv.get("money")) == 10, "dinero inicial 10")
	var stall: Node = main.get_node("Village/Mercado")
	inv.call("add_item", "huevo", 5)
	stall.call("interact", null)
	assert(int(inv.call("get_count", "huevo")) == 2, "vende excedente, reserva 2")
	assert(int(inv.call("get_count", "trigo")) == 2, "reserva trigo intacta")
	assert(int(inv.get("money")) == 10 + 3 * 3, "5-2 huevos x3 = +9")
	assert(String(stall.call("get_prompt")).contains("Comprar"), "sin excedente ofrece pack")
	var s_trigo: int = int(inv.call("get_count", "semilla_trigo"))
	stall.call("interact", null)
	assert(int(inv.get("money")) == 19 - 5, "pack cuesta 5")
	assert(int(inv.call("get_count", "semilla_trigo")) == s_trigo + 1, "pack suma semillas")
	inv.set("money", 2)
	stall.call("interact", null)
	assert(int(inv.get("money")) == 2, "sin monedas no compra")
	assert(String(stall.call("get_prompt")).contains("nada"), "prompt sin comercio")
	var save_sys: Node = root.get_node_or_null("SaveSystem")
	assert(bool(save_sys.call("save_game")), "guarda con dinero")
	inv.set("money", 999)
	assert(bool(save_sys.call("load_game")), "carga")
	assert(int(inv.get("money")) == 2, "carga restaura dinero")
	print("SMOKE012 OK")
