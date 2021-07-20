extends Node

var current_level: int
var current_level_data: Dictionary


func set_level(level: int) -> Dictionary:
	var file = File.new()
	file.open("res://data/levels/level" + str(level) + ".json", file.READ)
	var text = file.get_as_text()
	file.close()

	current_level_data = JSON.parse(text).result

	return current_level_data


func get_final_position(path_index: int, enemy_index: int) -> Vector2:
	var pos = current_level_data["paths"][path_index]["final_positions"][enemy_index]

	return Vector2(pos["x"], pos["y"])


func get_max_enemies(path_index: int) -> int:
	return current_level_data["paths"][path_index]["num_enemies"]
