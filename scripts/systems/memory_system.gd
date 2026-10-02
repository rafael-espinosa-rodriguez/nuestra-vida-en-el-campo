extends Node
## Album de recuerdos (GDD §48, spec 017). Autoload "MemorySystem".
## Primeras veces automaticas + fotos. Aviso toast en el HUD.

const MEMORABLE := ["huevo", "leche", "trigo", "pan", "sopa", "tortilla",
	"lana", "tela", "pez", "seta", "maiz", "calabaza", "madera"]

var memories: Array[String] = []
var photos_taken: int = 0


func has_memory(memory_id: String) -> bool:
	return memories.has(memory_id)


func remember(memory_id: String) -> bool:
	if memories.has(memory_id):
		return false
	memories.append(memory_id)
	_toast("¡Recuerdo: " + pretty(memory_id) + "!")
	return true


func remember_first(item_id: String) -> void:
	if MEMORABLE.has(item_id):
		remember("primero_" + item_id)


func pretty(memory_id: String) -> String:
	if memory_id.begins_with("primero_"):
		return "primer " + memory_id.trim_prefix("primero_")
	if memory_id.begins_with("foto_"):
		return "fotografía " + memory_id.trim_prefix("foto_")
	if memory_id.begins_with("amigo_"):
		return "amistad con " + memory_id.trim_prefix("amigo_").capitalize()
	return memory_id


func serialize() -> Dictionary:
	return {"memories": memories.duplicate(), "photos": photos_taken}


func deserialize(d: Dictionary) -> void:
	memories.clear()
	if d.has("memories") and typeof(d["memories"]) == TYPE_ARRAY:
		for m: Variant in d["memories"]:
			memories.append(String(m))
	photos_taken = int(d.get("photos", 0))


func _toast(text: String) -> void:
	for hud: Node in get_tree().get_nodes_in_group("hud"):
		if hud.has_method("show_message"):
			hud.show_message(text)
