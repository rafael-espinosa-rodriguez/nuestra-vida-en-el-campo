extends SceneTree
## Smoke spec 024: armario cambia camisa, taller hace cercas, cerca se coloca, decor extra.

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
	var player: Node = get_nodes_in_group("player")[0]
	var shirt0: int = int(player.get("shirt_idx"))
	_main.get_node("Armario").call("interact", player)
	assert(int(player.get("shirt_idx")) == (shirt0 + 1) % 4, "armario cambia camisa")
	inv.call("add_item", "madera", 4)
	_main.get_node("Taller").call("interact", player)
	_main.get_node("Taller").call("interact", player)
	assert(int(inv.call("get_count", "cerca")) == 2, "taller: 4 madera -> 2 cercas")
	assert(player.call("equip", "cerca"), "equipa cerca")
	var fences0: int = _count_fences()
	player.call("place_fence")
	assert(_count_fences() == fences0 + 1, "cerca colocada en el mundo")
	assert(int(inv.call("get_count", "cerca")) == 1, "colocar consume cerca")
	inv.set("money", 100)


func _count_fences() -> int:
	return get_nodes_in_group("fences").size()


func _phase_two() -> void:
	var inv: Node = root.get_node_or_null("InventorySystem")
	for i: int in 5:
		_main.get_node("Decor").call("interact", null)
	assert(bool(inv.call("has", "decor_cortina")), "compra cortina")
	assert(bool(inv.call("has", "decor_lampara")), "compra lampara")
	assert(bool(_main.get_node("House/DecorCortina").visible), "cortina visible")
	print("SMOKE024 OK")
