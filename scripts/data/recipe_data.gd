class_name RecipeData
extends Resource
## Datos de receta (GDD §§31-32). Crear .tres en resources/data/recipes/.

@export var recipe_id: String = "pan"
@export var display_name: String = "Pan"
## OJO: PackedStringArray a proposito. Con Array[String] el .tres no aplica
## el valor y se queda el default (bug detectado en smoke_008).
@export var ingredients: PackedStringArray = ["harina", "agua"]
@export var station: String = "horno"
