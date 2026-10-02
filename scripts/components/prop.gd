class_name Prop
extends InteractableArea3D
## Mueble/estacion interactuable (spec 006): cama, chimenea, horno, molino, pozo.
## La cocina es data-driven (resources/data/recipes/*.tres).

@export var prop_id: String = "bed"

const RECIPES := ["pan", "sopa", "tortilla"]
const COLORS := {"bed": Color(0.6, 0.4, 0.7), "fireplace": Color(0.5, 0.25, 0.15),
	"oven": Color(0.7, 0.7, 0.72), "mill": Color(0.75, 0.6, 0.4), "well": Color(0.55, 0.55, 0.6)}

var lit: bool = false

@onready var mesh: MeshInstance3D = $Mesh
@onready var glow: OmniLight3D = $Glow


func _ready() -> void:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = COLORS.get(prop_id, Color(0.8, 0.8, 0.8))
	mesh.set_surface_override_material(0, mat)
	glow.visible = false


func get_prompt() -> String:
	match prop_id:
		"bed":
			return "Dormir hasta mañana"
		"fireplace":
			return "Chimenea encendida" if lit else "Encender chimenea (1 madera)"
		"mill":
			return "Moler trigo -> harina"
		"oven":
			return "Cocinar (pan/sopa/tortilla)"
		"well":
			return "Sacar agua"
	return prompt


func interact(player: Node) -> void:
	if player == null or not (player is Player):
		return
	var pl: Player = player as Player
	var inv: Node = get_node_or_null("/root/InventorySystem")
	match prop_id:
		"bed":
			var time_sys: Node = get_node_or_null("/root/TimeSystem")
			if time_sys != null:
				time_sys.sleep_until_morning()
		"fireplace":
			if not lit and inv != null and bool(inv.call("remove_item", "madera")):
				lit = true
				glow.visible = true
				glow.light_color = Color(1.0, 0.55, 0.25)
		"mill":
			if inv != null and int(inv.call("get_count", "trigo")) >= 1 and pl.spend_energy(2.0):
				inv.call("remove_item", "trigo")
				inv.call("add_item", "harina")
		"oven":
			_cook(pl, inv)
		"well":
			if inv != null:
				inv.call("add_item", "agua")


func _cook(pl: Player, inv: Node) -> void:
	if inv == null:
		return
	for rid: String in RECIPES:
		var recipe: RecipeData = load("res://resources/data/recipes/" + rid + ".tres")
		if recipe == null:
			continue
		if _can_cook(recipe, inv) and pl.spend_energy(5.0):
			for ing: String in recipe.ingredients:
				inv.call("remove_item", ing)
			inv.call("add_item", recipe.recipe_id)
			return


func _can_cook(recipe: RecipeData, inv: Node) -> bool:
	var need := {}
	for ing: String in recipe.ingredients:
		need[ing] = int(need.get(ing, 0)) + 1
	for ing: String in need.keys():
		if int(inv.call("get_count", ing)) < int(need[ing]):
			return false
	return true
