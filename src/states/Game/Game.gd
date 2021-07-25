extends Node2D

onready var player = $Container/Player
onready var ui = $UI
onready var countdown = $UI/Countdown
var remaining_enemies: int = 0
var current_level: int = 1


func _ready():
	GameManager.connect("level_change", self, "_on_level_change")
	GameManager.connect("enemy_death", self, "_on_enemy_death")
	GameManager.connect("game_over", self, "_on_game_over")

	player.connect("auto_fire_state_change", self, "_on_player_auto_fire_state_change")
	player.connect("weapon_change", self, "_on_player_weapon_change")

	countdown.connect("countdown_end", self, "_on_level_start_timeout")

	player.initialise()
	GameManager.set_level(current_level)

	# ui.set_weapon(WeaponManager.weapon_data)


func _on_level_change(level: Level):
	print('level change')
	remaining_enemies = level.total_enemies
	ui.set_level(level)
	countdown.start(Globals.LEVEL_START_DELAY, level.name + " starts in")


func _on_player_auto_fire_state_change(has_autofire: bool):
	ui.set_auto_fire_state(has_autofire)


func _on_player_weapon_change(weapon_data):
	ui.set_weapon(weapon_data)


func _on_enemy_death():
	remaining_enemies -= 1
	ui.set_remaining_enemies(remaining_enemies)

	if remaining_enemies == 0:
		# TODO: End game?
		current_level += 1
		GameManager.set_level(current_level)


func _on_level_start_timeout():
	GameManager.start_level()


func _on_game_over():
	SceneManager.goto_scene("GameOver")
