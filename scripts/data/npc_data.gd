class_name NPCData
extends Resource
## Datos de vecino (GDD §42). .tres en resources/data/npcs/.

@export var display_name: String = "Vecino"
@export var age: int = 40
@export var profession: String = "vecino"
@export var personality: String = "amable"
@export var favorite_gift: String = "huevo"
@export var tint: Color = Color(0.5, 0.6, 0.8)
@export var dialogues: Dictionary = {
	"manana": ["Buenos dias. Hermosa mañana para el campo."],
	"dia": ["¿Como va la granja?"],
	"tarde": ["Que atardecer mas bonito."],
	"noche": ["Ya es tarde, descansa."],
}
