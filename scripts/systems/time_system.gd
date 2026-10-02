extends Node
## Reloj del juego (GDD §§7-8). Autoload. TODO spec 002.

signal day_changed(new_day: int)
signal time_changed(hour: float)

var current_day: int = 1
var hour: float = 6.0 ## 06:00 del dia 1
var day_length_minutes: float = 20.0 ## 15-25 configurable


func _process(delta: float) -> void:
	pass # TODO spec 002: avanzar hora, fases amanecer/dia/atardecer/noche.


func sleep_until_morning() -> void:
	pass


func is_night() -> bool:
	return hour < 6.0 or hour >= 21.0
