extends Control
## Menu principal (spec 026): nueva partida, continuar (si hay save), salir.

@onready var continue_button: Button = $Center/Menu/ContinueButton
@onready var new_button: Button = $Center/Menu/NewButton
@onready var quit_button: Button = $Center/Menu/QuitButton


func _ready() -> void:
	print("TITLE: menu listo")
	continue_button.disabled = not FileAccess.file_exists("user://savegame.json")
	new_button.pressed.connect(_on_new_button_pressed)
	continue_button.pressed.connect(_on_continue_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	new_button.grab_focus()


func new_game() -> void:
	if FileAccess.file_exists("user://savegame.json"):
		DirAccess.remove_absolute("user://savegame.json")
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	if time_sys != null:
		time_sys.set("current_day", 1)
		time_sys.set("hour", 6.0)
	var inv: Node = get_node_or_null("/root/InventorySystem")
	if inv != null and inv.has_method("clear_all"):
		inv.call("clear_all")
		inv.call("seed_starter_kit")
	_goto_main()


func continue_game() -> void:
	_goto_main()


func _goto_main() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")


func _on_new_button_pressed() -> void:
	print("TITLE: Nueva partida pulsado")
	new_game()


func _on_continue_button_pressed() -> void:
	print("TITLE: Continuar pulsado")
	continue_game()


func _on_quit_button_pressed() -> void:
	print("TITLE: Salir pulsado")
	get_tree().quit()
