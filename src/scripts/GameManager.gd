extends Node

signal enemy_death(enemy)
signal enemy_removed(enemy)
signal level_change(level)
signal level_start(level)
signal picked_powerup(powerup_data)
signal game_over

var current_level: Level


func set_level_index(index: int) -> void:
	if index >= len(Globals.LEVEL_LIST):
		emit_signal("game_over")
		return

	var level_name = Globals.LEVEL_LIST[index]
	var current_level_data = Utils.load_json("levels/" + level_name)

	if current_level_data == null:
		print(name, ": Failed to load level data")
		emit_signal("game_over")
	else:
		current_level = Level.new()
		current_level.set_level_data(current_level_data)

		emit_signal("level_change", current_level)


func enemy_dead(enemy):
	emit_signal("enemy_death", enemy)


func enemy_removed(enemy):
	emit_signal("enemy_removed", enemy)


func start_level():
	emit_signal("level_start")


func picked_powerup(powerup_data):
	emit_signal("picked_powerup", powerup_data)
