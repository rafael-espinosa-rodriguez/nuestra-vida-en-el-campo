class_name ItemData
extends Resource
## Datos de un item (GDD §59). .tres en resources/data/items/.
## category usa InventorySystem.Category: 0 agric, 1 animales, 2 materiales, 3 comida, 4 herramientas, 5 objetos.

@export var item_id: String = "huevo"
@export var display_name: String = "Huevo"
@export var category: int = 3
@export var max_stack: int = 20
