extends Node
## Inventario por categorias (GDD §59). Autoload "InventorySystem".

signal items_changed

enum Category { AGRICULTURA, ANIMALES, MATERIALES, COMIDA, HERRAMIENTAS, OBJETOS }

var items: Dictionary = {}
var money: int = 0


func _ready() -> void:
	# Kit inicial MVP (spec 003/008): herramientas + semillas para la primera semana.
	# Se aplica solo en partida nueva (inventario vacio); load_game lo sobrescribe.
	if items.is_empty():
		seed_starter_kit()


func seed_starter_kit() -> void:
	add_item("azada")
	add_item("regadera")
	add_item("hacha")
	add_item("cana")
	add_item("pico")
	add_item("semilla_trigo", 3)
	add_item("semilla_zanahoria", 2)
	add_item("semilla_tomate", 2)
	add_item("trigo", 2) # Despensa inicial: permite cocinar pan el D5 antes de la primera cosecha.
	money = 10 # Para la primera compra en el mercado (spec 012).


func add_item(item_id: String, amount: int = 1) -> void:
	items[item_id] = int(items.get(item_id, 0)) + amount
	items_changed.emit()
	var mem: Node = get_node_or_null("/root/MemorySystem")
	if mem != null and mem.has_method("remember_first"):
		mem.remember_first(item_id)


func remove_item(item_id: String, amount: int = 1) -> bool:
	if int(items.get(item_id, 0)) < amount:
		return false
	items[item_id] = int(items[item_id]) - amount
	if int(items[item_id]) <= 0:
		items.erase(item_id)
	items_changed.emit()
	return true


func get_count(item_id: String) -> int:
	return int(items.get(item_id, 0))


func has(item_id: String, amount: int = 1) -> bool:
	return get_count(item_id) >= amount


func clear_all() -> void:
	items.clear()
	items_changed.emit()
