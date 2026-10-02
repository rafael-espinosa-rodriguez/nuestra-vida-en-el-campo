class_name AnimalData
extends Resource
## Datos de especie animal (GDD §77). Crear .tres en resources/data/animals/.

@export var species: String = "gallina"
@export var display_name: String = "Gallina"
@export var hunger_max: int = 100
@export var produce_id: String = "huevo"
@export var produce_per_day: int = 1
@export var personalities: Array[String] = ["cariñoso", "tímido", "juguetón", "tranquilo", "curioso"]
