extends Node
## Clima por estacion (GDD §36, spec 015). Autoload "WeatherSystem".
## Tablas deterministicas por semana de estacion (dia 1-7). Invierno (nieve) en spec 016.

signal weather_changed(new_weather: int)

enum Weather { SOLEADO, NUBLADO, LLUVIA, NIEVE }

# Estacion (0 prim, 1 ver, 2 oto, 3 inv) -> {dia_en_temporada -> clima}.
const SEASON_WEEKS := {
	0: {1: 0, 2: 0, 3: 1, 4: 0, 5: 1, 6: 2, 7: 0},
	1: {1: 0, 2: 0, 3: 0, 4: 1, 5: 0, 6: 2, 7: 0},
	2: {1: 1, 2: 2, 3: 0, 4: 1, 5: 2, 6: 2, 7: 1},
	3: {1: 1, 2: 3, 3: 1, 4: 3, 5: 1, 6: 3, 7: 1},
}

var current: int = Weather.SOLEADO


func roll_daily_weather(day: int) -> void:
	# Pura en funcion del dia (TimeSystem llama tras avanzar, con day == current_day).
	var season: int = int((day - 1) / 7) % 4
	var day_in: int = int((day - 1) % 7) + 1
	var table: Dictionary = SEASON_WEEKS.get(season, SEASON_WEEKS[0])
	var w: int = int(table.get(day_in, Weather.SOLEADO))
	if w != current:
		current = w
		weather_changed.emit(current)
