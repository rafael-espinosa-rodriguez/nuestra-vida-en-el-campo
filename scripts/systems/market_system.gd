extends Node
## Mercado estacional y dinero local (GDD §§45-46, spec 012). Autoload "MarketSystem".
## Sin UI de tienda en MVP: E vende excedente (reserva 2); sin excedente compra pack semillas.

const SHOP_ID := "mercado_primavera"


func shop() -> ShopData:
	return load("res://resources/data/shops/" + SHOP_ID + ".tres") as ShopData


func surplus_value() -> int:
	var inv: Node = get_node_or_null("/root/InventorySystem")
	var data := shop()
	if inv == null or data == null:
		return 0
	var total := 0
	for item_id: String in (data.sell_prices as Dictionary).keys():
		var extra: int = int(inv.call("get_count", item_id)) - data.reserve
		if extra > 0:
			total += extra * int((data.sell_prices as Dictionary)[item_id])
	return total


func sell_surplus() -> int:
	var inv: Node = get_node_or_null("/root/InventorySystem")
	var data := shop()
	if inv == null or data == null:
		return 0
	var earned := 0
	for item_id: String in (data.sell_prices as Dictionary).keys():
		var extra: int = int(inv.call("get_count", item_id)) - data.reserve
		if extra > 0:
			inv.call("remove_item", item_id, extra)
			earned += extra * int((data.sell_prices as Dictionary)[item_id])
	if earned > 0:
		inv.set("money", int(inv.get("money")) + earned)
		_sfx("coin")
	return earned


func can_buy_pack() -> bool:
	return _pack_price() >= 0 and _money() >= _pack_price()


func pack_price() -> int:
	return _pack_price()


func buy_seed_pack() -> bool:
	var inv: Node = get_node_or_null("/root/InventorySystem")
	var data := shop()
	if inv == null or data == null:
		return false
	var price := _pack_price()
	if price < 0 or _money() < price:
		return false
	inv.set("money", _money() - price)
	for seed_id: String in data.seed_pack:
		inv.call("add_item", seed_id)
	_sfx("coin")
	return true


func _pack_price() -> int:
	var data := shop()
	if data == null:
		return -1
	# En festival el pack cuesta la mitad (GDD §50).
	if _is_festival():
		return maxi(1, int(data.seed_pack_price / 2))
	return data.seed_pack_price


func _is_festival() -> bool:
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	return time_sys != null and time_sys.has_method("is_festival_day") and bool(time_sys.call("is_festival_day"))


func _money() -> int:
	var inv: Node = get_node_or_null("/root/InventorySystem")
	return int(inv.get("money")) if inv != null else 0


func _sfx(sfx_id: String) -> void:
	var audio: Node = get_node_or_null("/root/AudioSystem")
	if audio != null and audio.has_method("sfx"):
		audio.sfx(sfx_id)
