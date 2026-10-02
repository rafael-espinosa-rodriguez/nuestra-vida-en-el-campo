class_name InteractableArea3D
extends Area3D
## Convencion de interaccion generica (GDD §79): todo nodo interactuable
## implementa get_prompt() -> String e interact(player) -> void (duck-typing).

@export var prompt: String = "Interactuar"


func get_prompt() -> String:
	return prompt


func interact(_player: Node) -> void:
	push_warning("InteractableArea3D sin override de interact()")
