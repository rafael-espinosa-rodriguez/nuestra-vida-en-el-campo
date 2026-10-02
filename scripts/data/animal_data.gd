class_name AnimalData
extends Resource
## Datos de especie animal (GDD §77). Crear .tres en resources/data/animals/.

@export var species: String = "gallina"
@export var display_name: String = "Gallina"
@export var hunger_max: int = 100
@export var produce_id: String = "huevo"
@export var produce_per_day: int = 1
@export var personalities: Array[String] = ["cariñoso", "tímido", "juguetón", "tranquilo", "curioso"]
@export var food_id: String = "trigo"
@export var follows_player: bool = false
@export var rideable: bool = false
@export var tint: Color = Color(1, 1, 1)
@export var body_size: Vector3 = Vector3(0.5, 0.5, 0.7)
@export var walk_speed: float = 1.2
