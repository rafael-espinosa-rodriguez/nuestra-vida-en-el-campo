extends Node
## Clima MVP: soleado/nublado/lluvia (GDD §36). Autoload "WeatherSystem".
## Semana determinista (spec 007/008): D6 lluvia siempre; resto fijo para el guion.

signal weather_changed(new_weather: int)

enum Weather { SOLEADO, NUBLADO, LLUVIA }

# Dia -> clima (1-7). Post-MVP: aleatorio por estacion.
const WEEK := {1: 0, 2: 0, 3: 1, 4: 0, 5: 1, 6: 2, 7: 0}

var current: int = Weather.SOLEADO


func roll_daily_weather(day: int) -> void:
	var w: int = int(WEEK.get(day, Weather.SOLEADO))
	if w != current:
		current = w
		weather_changed.emit(current)
