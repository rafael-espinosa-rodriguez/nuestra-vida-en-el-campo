extends SceneTree
## Smoke spec 009: pueblo fisico instanciado con edificios, plaza, puesto y señales.

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
	var village: Node = main.get_node_or_null("Village")
	assert(village != null, "existe Village")
	for n: String in ["CasaA", "CasaB", "Tienda", "Herreria", "Plaza", "Puesto", "Farola1", "Farola2", "TiendaSign", "HerreriaSign"]:
		assert(village.get_node_or_null(n) != null, "existe " + n)
	var sign: Node = village.get_node("TiendaSign")
	assert(String(sign.call("get_prompt")).contains("Mara"), "cartel tienda")
	assert(String(main.get_node("VillageSign").call("get_prompt")).contains("Pueblo"), "cartel camino al pueblo")
	print("SMOKE009 OK")
