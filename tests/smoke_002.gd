extends SceneTree
## Smoke spec 002: dormir avanza dia + autosave; load restaura dia/hora/inventario.
## Uso: Godot_console.exe --headless --path <proyecto> --script res://tests/smoke_002.gd
## (Con --script los autoloads se resuelven via root.get_node, no por nombre global.)

var _frames := 0


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames == 5:
		_run()
		quit()
	return false


func _sys(path_name: String) -> Node:
	return root.get_node_or_null(path_name)


func _run() -> void:
	var time_sys: Node = _sys("TimeSystem")
	var save_sys: Node = _sys("SaveSystem")
	var inv_sys: Node = _sys("InventorySystem")
	assert(time_sys != null and save_sys != null and inv_sys != null, "autoloads presentes")
	assert(int(time_sys.get("current_day")) == 1, "empieza en dia 1")
	inv_sys.call("clear_all")
	inv_sys.call("add_item", "trigo", 3)
	time_sys.call("sleep_until_morning")
	assert(int(time_sys.get("current_day")) == 2, "dormir avanza al dia 2")
	assert(float(time_sys.get("hour")) == 6.0, "despierta a las 06:00")
	assert(bool(save_sys.call("has_save")), "autosave al dormir")
	assert(int(inv_sys.call("get_count", "trigo")) == 3, "inventario intacto tras dormir")
	time_sys.set("hour", 20.0)
	inv_sys.call("add_item", "trigo", 99)
	assert(bool(save_sys.call("load_game")), "load_game devuelve true")
	assert(int(time_sys.get("current_day")) == 2 and float(time_sys.get("hour")) == 6.0, "carga restaura dia/hora")
	assert(int(inv_sys.call("get_count", "trigo")) == 3, "carga restaura inventario")
	print("SMOKE002 OK")
