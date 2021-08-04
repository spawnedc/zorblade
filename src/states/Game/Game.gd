extends Node2D

onready var player = $Container/Player
onready var ui = $UI
onready var countdown = $UI/Countdown
var remaining_enemies: int = 0
var remaining_enemies_to_remove: int = 0
var current_level_number: int = 1
var current_level: Level


func _ready():
	GameManager.connect("level_change", self, "_on_level_change")
	GameManager.connect("enemy_death", self, "_on_enemy_death")
	GameManager.connect("enemy_removed", self, "_on_enemy_removed")
	GameManager.connect("game_over", self, "_on_game_over")
	GameManager.connect("picked_powerup", self, "_on_picked_powerup")

	player.connect("auto_fire_state_change", self, "_on_player_auto_fire_state_change")
	player.connect("weapon_change", self, "_on_player_weapon_change")

	countdown.connect("countdown_end", self, "_on_level_start_timeout")

	player.initialise()
	GameManager.set_level(current_level_number)


func _on_level_change(level: Level):
	current_level = level
	remaining_enemies = level.total_enemies
	remaining_enemies_to_remove = remaining_enemies

	ui.set_level(level)
	countdown.start(Globals.LEVEL_START_DELAY, level.name)

	if current_level_number == 1:
		MusicManager.play(current_level.music)
	else:
		MusicManager.stop()


func _on_player_auto_fire_state_change(has_autofire: bool):
	ui.set_auto_fire_state(has_autofire)


func _on_player_weapon_change(weapon_data):
	ui.set_weapon(weapon_data)


func _on_enemy_death(_enemy):
	remaining_enemies -= 1
	ui.set_remaining_enemies(remaining_enemies)


func _on_enemy_removed(_enemy):
	remaining_enemies_to_remove -= 1

	if remaining_enemies_to_remove == 0:
		# TODO: End game?
		current_level_number += 1
		GameManager.set_level(current_level_number)


func _on_level_start_timeout():
	GameManager.start_level()

	if current_level_number > 1:
		MusicManager.play(current_level.music)


func _on_game_over():
	SceneManager.goto_scene("GameOver")
	MusicManager.stop()


func _on_picked_powerup(powerup_data):
	print("picked up powerup", powerup_data)
	if powerup_data["weapon"]:
		player.set_weapon(powerup_data["weapon"])
