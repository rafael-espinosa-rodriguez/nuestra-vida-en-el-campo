extends SceneTree
## Smoke spec 003: kit inicial, equipar herramientas, energia, huevo al inventario.

var _frames := 0


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames == 5:
		_run()
		quit()
	return false


func _run() -> void:
	var inv_sys: Node = root.get_node_or_null("InventorySystem")
	assert(inv_sys != null, "autoload inventario")
	assert(int(inv_sys.call("get_count", "azada")) >= 1, "kit trae azada")
	assert(int(inv_sys.call("get_count", "regadera")) >= 1, "kit trae regadera")
	assert(int(inv_sys.call("get_count", "semilla_trigo")) >= 1, "kit trae semillas")
	inv_sys.call("add_item", "huevo", 2)
	assert(int(inv_sys.call("get_count", "huevo")) == 2, "huevo suma al inventario")
	assert(inv_sys.call("remove_item", "huevo", 5) == false, "no quita lo que no hay")
	assert(int(inv_sys.call("get_count", "huevo")) == 2, "fallo no descuenta")
	print("SMOKE003 OK")
