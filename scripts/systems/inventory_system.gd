extends Node
## Inventario por categorias (GDD §59). Autoload. TODO spec 003.

enum Category { AGRICULTURA, ANIMALES, MATERIALES, COMIDA, HERRAMIENTAS, OBJETOS }

var items: Dictionary = {}


func add_item(item_id: String, amount: int = 1) -> void:
	items[item_id] = int(items.get(item_id, 0)) + amount


func remove_item(item_id: String, amount: int = 1) -> bool:
	if int(items.get(item_id, 0)) < amount:
		return false
	items[item_id] -= amount
	return true
