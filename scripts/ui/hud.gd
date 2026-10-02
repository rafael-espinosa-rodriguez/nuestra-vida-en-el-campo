extends CanvasLayer
## HUD minimalista (GDD §58): hora, dia/estacion, clima, energia, herramienta, prompt.
## Se actualiza cada frame desde los autoloads + Player.

@onready var time_label: Label = $TopLeft/TimeLabel
@onready var weather_label: Label = $TopLeft/WeatherLabel
@onready var energy_bar: ProgressBar = $TopLeft/EnergyBar
@onready var tool_label: Label = $TopLeft/ToolLabel
@onready var prompt_label: Label = $Prompt/PromptLabel


func _process(_delta: float) -> void:
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	if time_sys != null:
		var h: float = float(time_sys.get("hour"))
		time_label.text = "Dia %d  %02d:%02d  ·  Primavera" % [int(time_sys.get("current_day")), int(h), int((h - floor(h)) * 60.0)]
	var weather: Node = get_node_or_null("/root/WeatherSystem")
	if weather != null:
		weather_label.text = ["☀ Soleado", "☁ Nublado", "🌧 Lluvia"][clampi(int(weather.get("current")), 0, 2)]
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if not players.is_empty():
		var p: Node = players[0]
		energy_bar.value = float(p.get("energy"))
		energy_bar.max_value = float(p.get("max_energy"))
		var tool: String = String(p.get("equipped_tool"))
		tool_label.text = ("🔨 " + tool) if tool != "" else "🔨 manos"
		prompt_label.text = String(p.get("current_prompt"))
