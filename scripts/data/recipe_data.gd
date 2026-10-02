class_name RecipeData
extends Resource
## Datos de receta (GDD §§31-32). Crear .tres en resources/data/recipes/.

@export var recipe_id: String = "pan"
@export var display_name: String = "Pan"
@export var ingredients: Array[String] = ["harina", "agua"]
@export var station: String = "horno"
