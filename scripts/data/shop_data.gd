class_name ShopData
extends Resource
## Puesto de mercado estacional (GDD §45). .tres en resources/data/shops/.
## sell_prices: lo que paga por tus productos. seed_pack: semillas que vende en pack.

@export var shop_id: String = "mercado_primavera"
@export var seller: String = "Mara"
@export var season: String = "primavera"
@export var sell_prices: Dictionary = {"huevo": 3, "leche": 5, "trigo": 2, "zanahoria": 3, "tomate": 4, "madera": 2, "harina": 3, "pan": 8, "sopa": 12, "tortilla": 7}
@export var seed_pack: PackedStringArray = ["semilla_trigo", "semilla_zanahoria", "semilla_tomate"]
@export var seed_pack_price: int = 5
@export var reserve: int = 2
