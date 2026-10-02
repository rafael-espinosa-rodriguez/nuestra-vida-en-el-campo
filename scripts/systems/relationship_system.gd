extends Node
## Amistad y trueque (GDD §§43-44, spec 011). Autoload "RelationshipSystem".
## Niveles: 0 desconocido, 1 conocido (20), 2 amigo (50). Tope 2 regalos/dia (anti-grind).

signal points_changed(npc_name: String, points: int)

const LEVEL_NAMES := ["desconocido", "conocido", "amigo"]
const GIFTS_PER_DAY := 2
const TRADE_IDS := ["mara_huevos"]

var points: Dictionary = {}
var _gifts_day: Dictionary = {}


func _ready() -> void:
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	if time_sys != null:
		time_sys.connect("day_changed", _on_new_day)


func _on_new_day(_day: int) -> void:
	_gifts_day.clear()


func get_points(npc_name: String) -> int:
	return int(points.get(npc_name, 0))


func level_of(npc_name: String) -> int:
	var p := get_points(npc_name)
	if p >= 50:
		return 2
	if p >= 20:
		return 1
	return 0


func level_name(npc_name: String) -> String:
	return LEVEL_NAMES[level_of(npc_name)]


func _today_count(npc_name: String) -> int:
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	var day: int = int(time_sys.get("current_day")) if time_sys != null else 1
	var rec: Dictionary = _gifts_day.get(npc_name, {"day": 0, "count": 0})
	if int(rec.get("day", 0)) != day:
		return 0
	return int(rec.get("count", 0))


func gift(npc_name: String, item_id: String) -> int:
	# Devuelve puntos ganados; 0 si tope diario; -1 si no hay item.
	# En dia de festival (fin de temporada) los regalos valen doble (GDD §50).
	var inv: Node = get_node_or_null("/root/InventorySystem")
	if inv == null or not bool(inv.call("has", item_id)):
		return -1
	if _today_count(npc_name) >= GIFTS_PER_DAY:
		return 0
	if not bool(inv.call("remove_item", item_id)):
		return -1
	var gained := 3
	var npc: Node = _find_npc(npc_name)
	if npc != null and npc.get("data") != null and String(npc.get("data").get("favorite_gift")) == item_id:
		gained = 8
	if _is_festival():
		gained *= 2
		_festival_toast()
	_add_points(npc_name, gained)
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	var day: int = int(time_sys.get("current_day")) if time_sys != null else 1
	_gifts_day[npc_name] = {"day": day, "count": _today_count(npc_name) + 1}
	return gained


func gift_auto(npc_name: String) -> int:
	var inv: Node = get_node_or_null("/root/InventorySystem")
	if inv == null:
		return -1
	var npc: Node = _find_npc(npc_name)
	if npc != null and npc.get("data") != null:
		var fav := String(npc.get("data").get("favorite_gift"))
		if bool(inv.call("has", fav)):
			return gift(npc_name, fav)
	for item_id: String in ["huevo", "pan", "tortilla", "leche", "manzana", "zanahoria", "tomate"]:
		if bool(inv.call("has", item_id)):
			return gift(npc_name, item_id)
	return -1


func trade_with(trader_name: String) -> String:
	var inv: Node = get_node_or_null("/root/InventorySystem")
	if inv == null:
		return ""
	for tid: String in TRADE_IDS:
		var trade: TradeData = load("res://resources/data/trades/" + tid + ".tres")
		if trade == null or trade.trader != trader_name:
			continue
		if int(inv.call("get_count", trade.give_id)) < trade.give_n:
			continue
		inv.call("remove_item", trade.give_id, trade.give_n)
		inv.call("add_item", trade.receive_id, trade.receive_n)
		_add_points(trader_name, 5)
		return trade.receive_id
	return ""


func serialize() -> Dictionary:
	return {"points": points.duplicate()}


func deserialize(d: Dictionary) -> void:
	points.clear()
	if d.has("points") and typeof(d["points"]) == TYPE_DICTIONARY:
		for k: String in (d["points"] as Dictionary).keys():
			points[k] = int((d["points"] as Dictionary)[k])
	_gifts_day.clear()


func _add_points(npc_name: String, n: int) -> void:
	points[npc_name] = get_points(npc_name) + n
	points_changed.emit(npc_name, int(points[npc_name]))


func is_festival() -> bool:
	return _is_festival()


func _is_festival() -> bool:
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	return time_sys != null and time_sys.has_method("is_festival_day") and bool(time_sys.call("is_festival_day"))


func _festival_toast() -> void:
	for hud: Node in get_tree().get_nodes_in_group("hud"):
		if hud.has_method("show_message"):
			hud.call("show_message", "¡Festival! Regalos x2 hoy")


func _find_npc(npc_name: String) -> Node:
	for a: Node in get_tree().get_nodes_in_group("npcs"):
		if String(a.get("npc_name")) == npc_name:
			return a
	return null
