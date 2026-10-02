extends Node
## Clima MVP: soleado/nublado/lluvia (GDD §36). Autoload. TODO spec 007.

enum Weather { SOLEADO, NUBLADO, LLUVIA }

var current: Weather = Weather.SOLEADO


func roll_daily_weather(day: int) -> void:
	if day == 6:
		current = Weather.LLUVIA
