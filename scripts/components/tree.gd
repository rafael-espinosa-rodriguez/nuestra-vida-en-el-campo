class_name FarmTree
extends InteractableArea3D
## Arbol talable del bosque (GDD §28, spec 007): hacha + energia -> madera.
## Rebrota con el tiempo (tick propio en day_changed).

var felled: bool = false

@onready var trunk: MeshInstance3D = $Trunk
@onready var leaves: MeshInstance3D = $Leaves


func _ready() -> void:
	add_to_group("trees")
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	if time_sys != null:
		time_sys.connect("day_changed", _on_new_day)


func get_prompt() -> String:
	return "Talar (hacha)" if not felled else "Tocón (rebrotando...)"


func interact(player: Node) -> void:
	if felled or player == null or not (player is Player):
		return
	var pl: Player = player as Player
	if pl.equipped_tool == "hacha" and pl.spend_energy(10.0):
		fell()


func fell() -> void:
	if felled:
		return
	felled = true
	leaves.visible = false
	trunk.scale.y = 0.25
	var inv: Node = get_node_or_null("/root/InventorySystem")
	if inv != null:
		inv.call("add_item", "madera", 2)


func _on_new_day(_day: int) -> void:
	if felled and randf() < 0.35:
		felled = false
		leaves.visible = true
		trunk.scale.y = 1.0
