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
	return earned


func can_buy_pack() -> bool:
	var inv: Node = get_node_or_null("/root/InventorySystem")
	var data := shop()
	return inv != null and data != null and int(inv.get("money")) >= data.seed_pack_price


func buy_seed_pack() -> bool:
	var inv: Node = get_node_or_null("/root/InventorySystem")
	var data := shop()
	if inv == null or data == null:
		return false
	if int(inv.get("money")) < data.seed_pack_price:
		return false
	inv.set("money", int(inv.get("money")) - data.seed_pack_price)
	for seed_id: String in data.seed_pack:
		inv.call("add_item", seed_id)
	return true
