extends Node
## Guardado robusto en user://savegame.json (GDD §80). Autoload. TODO spec 002.

const SAVE_PATH := "user://savegame.json"
const SAVE_VERSION := 1


func save_game() -> void:
	pass # TODO: posicion, dia, estacion, clima, inventario, animales, cultivos, dinero, recuerdos.


func load_game() -> void:
	pass


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
