class_name Prop
extends InteractableArea3D
## Mueble/estacion interactuable (spec 006): cama, chimenea, horno, molino, pozo.
## La cocina es data-driven (resources/data/recipes/*.tres).

@export var prop_id: String = "bed"
@export var info_text: String = ""
@export var forage_id: String = "seta"

const RECIPES := ["pan", "sopa", "tortilla"]
const COLORS := {"bed": Color(0.6, 0.4, 0.7), "fireplace": Color(0.5, 0.25, 0.15),
	"oven": Color(0.7, 0.7, 0.72), "mill": Color(0.75, 0.6, 0.4), "well": Color(0.55, 0.55, 0.6),
	"sign": Color(0.65, 0.5, 0.3), "market": Color(0.8, 0.4, 0.25),
	"fish": Color(0.35, 0.6, 0.85), "forage": Color(0.4, 0.6, 0.3),
	"telar": Color(0.7, 0.5, 0.65), "decor": Color(0.85, 0.7, 0.5),
	"corral": Color(0.55, 0.45, 0.3), "quesera": Color(0.9, 0.85, 0.55),
	"conservera": Color(0.5, 0.65, 0.45)}

const DECOR_CATALOG := [
	{"id": "decor_maceta", "name": "Maceta", "price": 10, "node": "DecorMaceta"},
	{"id": "decor_cuadro", "name": "Cuadro", "price": 15, "node": "DecorCuadro"},
	{"id": "decor_alfombra", "name": "Alfombra", "price": 20, "node": "DecorAlfombra"},
]

var lit: bool = false
var depleted: bool = false

@onready var mesh: MeshInstance3D = $Mesh
@onready var glow: OmniLight3D = $Glow


func _ready() -> void:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = COLORS.get(prop_id, Color(0.8, 0.8, 0.8))
	mesh.set_surface_override_material(0, mat)
	glow.visible = false
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	if time_sys != null and prop_id == "forage":
		time_sys.connect("day_changed", _on_new_day)


func _on_new_day(_day: int) -> void:
	if prop_id == "forage":
		depleted = false
		mesh.visible = true


func _process(delta: float) -> void:
	if prop_id == "decor":
		_sync_decor()
	# Aura de calor: junto a la chimenea encendida se recupera energia (GDD §13).
	if prop_id != "fireplace" or not lit:
		return
	for p: Node in get_tree().get_nodes_in_group("player"):
		if p is Node3D and global_position.distance_to((p as Node3D).global_position) < 4.0 and p.has_method("restore_energy"):
			p.restore_energy(2.0 * delta)


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
		"market":
			var market: Node = get_node_or_null("/root/MarketSystem")
			if market != null:
				if int(market.call("surplus_value")) > 0:
					return "Vender excedente (+%d)" % int(market.call("surplus_value"))
				if bool(market.call("can_buy_pack")):
					return "Comprar pack semillas (%d)" % int(market.call("pack_price"))
			return "Mercado (nada que comerciar)"
		"fish":
			return "Pescar (caña)"
		"forage":
			return "Recoger " + forage_id if not depleted else "Ya recogido (vuelve mañana)"
		"telar":
			return "Tejer tela (2 lana)"
		"quesera":
			return "Hacer queso/yogur (leche)"
		"conservera":
			return "Encurtir (zanahoria+tomate)"
		"corral":
			return "Criar (2 adultos + 2 trigo)"
		"decor":
			var next_decor: Dictionary = _next_decor()
			if next_decor.is_empty():
				return "Casa decorada"
			return "Comprar %s (%d)" % [String(next_decor["name"]), int(next_decor["price"])]
		"sign":
			return info_text if info_text != "" else "Cartel"
	return prompt


func interact(player: Node) -> void:
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
			if pl != null and inv != null and int(inv.call("get_count", "trigo")) >= 1 and pl.spend_energy(2.0):
				inv.call("remove_item", "trigo")
				inv.call("add_item", "harina")
		"oven":
			if pl != null:
				_cook(pl, inv, RECIPES)
		"well":
			if inv != null:
				inv.call("add_item", "agua")
		"market":
			var market: Node = get_node_or_null("/root/MarketSystem")
			if market != null:
				if int(market.call("surplus_value")) > 0:
					market.call("sell_surplus")
				else:
					market.call("buy_seed_pack")
		"fish":
			if pl != null and pl.equipped_tool == "cana" and pl.spend_energy(5.0) and inv != null:
				inv.call("add_item", "pez")
		"forage":
			if not depleted and inv != null:
				depleted = true
				mesh.visible = false
				inv.call("add_item", forage_id)
		"telar":
			if pl != null and inv != null and int(inv.call("get_count", "lana")) >= 2 and pl.spend_energy(4.0):
				inv.call("remove_item", "lana", 2)
				inv.call("add_item", "tela")
		"quesera":
			if pl != null:
				_cook(pl, inv, ["queso", "yogur"])
		"conservera":
			if pl != null:
				_cook(pl, inv, ["encurtido"])
		"corral":
			var herd: Node = get_node_or_null("/root/AnimalSystem")
			if herd != null:
				for species: String in ["gallina", "vaca", "oveja", "cabra"]:
					if String(herd.call("breed", species)) != "":
						return
		"decor":
			_buy_decor()


func _next_decor() -> Dictionary:
	var inv: Node = get_node_or_null("/root/InventorySystem")
	for entry: Dictionary in DECOR_CATALOG:
		if inv == null or not bool(inv.call("has", String(entry["id"]))):
			return entry
	return {}


func _buy_decor() -> void:
	var inv: Node = get_node_or_null("/root/InventorySystem")
	if inv == null:
		return
	var entry := _next_decor()
	if entry.is_empty():
		return
	if int(inv.get("money")) < int(entry["price"]):
		return
	inv.set("money", int(inv.get("money")) - int(entry["price"]))
	inv.call("add_item", String(entry["id"]))
	var mem: Node = get_node_or_null("/root/MemorySystem")
	if mem != null:
		mem.call("remember", "decor_" + String(entry["id"]))
	_sync_decor()


func _sync_decor() -> void:
	if prop_id != "decor":
		return
	var inv: Node = get_node_or_null("/root/InventorySystem")
	if inv == null:
		return
	for entry: Dictionary in DECOR_CATALOG:
		for node: Node in get_tree().get_nodes_in_group(String(entry["node"])):
			if node is MeshInstance3D:
				(node as MeshInstance3D).visible = bool(inv.call("has", String(entry["id"])))


func _cook(pl: Player, inv: Node, rids: Array = RECIPES) -> void:
	if inv == null:
		return
	for rid: String in rids:
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
