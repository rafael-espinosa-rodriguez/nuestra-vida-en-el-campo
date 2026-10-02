extends SceneTree
## Smoke spec 022: montar/desmontar, el caballo se mueve con WASD y lleva al jugador.

var _frames := 0
var _horse: Node
var _player: Node
var _start: Vector3


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames == 5:
		_phase_mount()
	if _frames == 60:
		_phase_moved()
		quit()
	return false


func _phase_mount() -> void:
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	_horse = root.get_node_or_null("AnimalSystem").call("find", "Bruno")
	_player = get_nodes_in_group("player")[0]
	assert(_horse != null, "existe Bruno")
	assert(String(_horse.call("get_prompt")) == "Montar", "prompt montar")
	_horse.call("interact", _player)
	assert(bool(_horse.get("ridden")), "montado")
	assert(String(_horse.call("get_prompt")) == "Desmontar", "prompt desmontar")
	_start = (_horse as Node3D).global_position
	Input.action_press("move_forward")


func _phase_moved() -> void:
	Input.action_release("move_forward")
	var moved: float = (_horse as Node3D).global_position.distance_to(_start)
	assert(moved > 2.0, "el caballo avanza con WASD")
	var d: float = (_player as Node3D).global_position.distance_to((_horse as Node3D).global_position)
	assert(d < 2.5, "el jugador viaja encima")
	_horse.call("interact", _player)
	assert(bool(_horse.get("ridden")) == false, "desmonta")
	assert(int((_player as Node).get("collision_layer")) == 1, "colision restaurada")
	print("SMOKE022 OK")
