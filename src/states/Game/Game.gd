extends Node2D

onready var player = $player
onready var ui = $UI
onready var countdown = $UI/Countdown
var remaining_enemies: int = 0
var current_level: int = 1


func _ready():
	WeaponManager.connect("weapon_change", ui, "set_weapon")
	GameManager.connect("level_change", self, "_on_level_change")
	GameManager.connect("enemy_death", self, "_on_enemy_death")
	player.connect("auto_fire_state_change", self, "_on_player_auto_fire_state_change")
	countdown.connect("countdown_end", self, "_on_level_start_timeout")

	GameManager.set_level(current_level)

	ui.set_weapon(WeaponManager.weapon_data)


func _on_level_change(level: Level):
	remaining_enemies = level.total_enemies
	ui.set_level(level)
	countdown.start(Globals.LEVEL_START_DELAY, level.name + " starts in")


func _on_player_auto_fire_state_change(has_autofire: bool):
	ui.set_auto_fire_state(has_autofire)


func _on_enemy_death():
	remaining_enemies -= 1
	ui.set_remaining_enemies(remaining_enemies)

	if remaining_enemies == 0:
		# TODO: End game?
		current_level += 1
		GameManager.set_level(current_level)


func _on_level_start_timeout():
	GameManager.start_level()
