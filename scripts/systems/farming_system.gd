extends Node
## Sistema de agricultura (GDD §§23-26, spec 004). Autoload "FarmingSystem".
## Avanza cultivos con TimeSystem.day_changed; la lluvia riega sola.


func _ready() -> void:
	var time_sys: Node = get_node_or_null("/root/TimeSystem")
	if time_sys != null:
		time_sys.connect("day_changed", on_new_day)


func on_new_day(_day: int) -> void:
	var weather: Node = get_node_or_null("/root/WeatherSystem")
	if weather != null and int(weather.get("current")) in [2, 3]:
		water_all()
	for plot: Node in get_tree().get_nodes_in_group("plots"):
		if plot.has_method("new_day"):
			plot.new_day()


func water_all() -> void:
	for plot: Node in get_tree().get_nodes_in_group("plots"):
		if plot.has_method("water"):
			plot.water()


func serialize() -> Array:
	var out := []
	for plot: Node in get_tree().get_nodes_in_group("plots"):
		if plot.has_method("serialize"):
			out.append(plot.serialize())
	return out


func deserialize(arr: Array) -> void:
	var by_name := {}
	for plot: Node in get_tree().get_nodes_in_group("plots"):
		by_name[String((plot as Node).name)] = plot
	for d: Variant in arr:
		if typeof(d) == TYPE_DICTIONARY and by_name.has(String(d.get("name", ""))):
			by_name[String(d.get("name", ""))].deserialize(d)
