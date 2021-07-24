extends Node

signal enemy_death
signal level_change(level)
signal level_start
signal game_over

const Level = preload("res://scripts/classes/Level.gd")
var current_level: Level


func set_level(level: int) -> void:
	var file = File.new()
	var file_open_result = file.open("res://data/levels/level" + str(level) + ".json", file.READ)

	if file_open_result != OK:
		emit_signal("game_over")
	else:
		var text = file.get_as_text()
		file.close()

		var current_level_data: Dictionary = JSON.parse(text).result

		current_level = Level.new(current_level_data)

		emit_signal("level_change", current_level)


func enemy_dead():
	emit_signal("enemy_death")


func start_level():
	emit_signal("level_start")
