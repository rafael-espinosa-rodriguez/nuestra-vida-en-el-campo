extends Node
## Inventario por categorias (GDD §59). Autoload "InventorySystem".

signal items_changed

enum Category { AGRICULTURA, ANIMALES, MATERIALES, COMIDA, HERRAMIENTAS, OBJETOS }

var items: Dictionary = {}


func add_item(item_id: String, amount: int = 1) -> void:
	items[item_id] = int(items.get(item_id, 0)) + amount
	items_changed.emit()


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
