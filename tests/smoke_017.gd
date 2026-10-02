extends SceneTree
## Smoke spec 017: recuerdos de primeras veces, toast HUD, foto elegante en headless, save/load.

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
	var mem: Node = root.get_node_or_null("MemorySystem")
	var inv: Node = root.get_node_or_null("InventorySystem")
	var player: Node = get_nodes_in_group("player")[0]
	assert(mem != null, "autoload recuerdos")
	inv.call("add_item", "huevo", 1)
	assert(bool(mem.call("has_memory", "primero_huevo")), "recuerdo del primer huevo")
	assert(bool(mem.call("remember", "primero_huevo")) == false, "no duplica")
	var hud: Node = get_nodes_in_group("hud")[0]
	assert(String(hud.get_node("Message").get("text")).contains("Recuerdo"), "toast visible en HUD")
	assert(bool(mem.call("remember", "nuestro_primer_invierno")), "recuerdo manual")
	assert(String(mem.call("pretty", "primero_huevo")) == "primer huevo", "texto bonito")
	assert(bool(player.call("capture_photo")) == false, "foto headless falla con elegancia")
	assert(int(mem.get("photos_taken")) == 0, "sin foto no cuenta")
	var save_sys: Node = root.get_node_or_null("SaveSystem")
	assert(bool(save_sys.call("save_game")), "guarda con recuerdos")
	mem.call("deserialize", {"memories": [], "photos": 0})
	assert(bool(mem.call("has_memory", "primero_huevo")) == false, "limpio")
	assert(bool(save_sys.call("load_game")), "carga")
	assert(bool(mem.call("has_memory", "primero_huevo")), "carga restaura recuerdos")
	print("SMOKE017 OK")
