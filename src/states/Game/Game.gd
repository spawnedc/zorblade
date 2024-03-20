extends Control

@onready var player = $Container/Player
@onready var ui = $UI
@onready var countdown = $UI/Countdown
var remaining_enemies: int = 0
var remaining_enemies_to_remove: int = 0
var level_index: int = 0
var current_level: Level
var score: int = 0


func _ready():
	GameManager.connect("level_change", Callable(self, "_on_level_change"))
	GameManager.connect("enemy_death", Callable(self, "_on_enemy_death"))
	GameManager.connect("enemy_removed", Callable(self, "_on_enemy_removed"))
	GameManager.connect("game_over", Callable(self, "_on_game_over"))
	GameManager.connect("picked_powerup", Callable(self, "_on_picked_powerup"))

	player.connect("auto_fire_state_change", Callable(ui, "set_auto_fire_state"))
	player.connect("weapon_change", Callable(ui, "set_weapon"))
	player.connect("speed_change", Callable(ui, "set_velocity"))
	player.connect("bullet_count_change", Callable(ui, "set_bullet_count"))
	player.connect("lives_change", Callable(ui, "set_lives"))

	countdown.connect("countdown_end", Callable(self, "_on_level_start_timeout"))

	player.initialise()
	ui.set_score(score)
	GameManager.set_level_index(level_index)


func _on_level_change(level: Level):
	current_level = level
	remaining_enemies = level.total_enemies
	remaining_enemies_to_remove = remaining_enemies

	ui.set_level(level)
	countdown.start(Globals.LEVEL_START_DELAY, level.name)

	if level_index == 0:
		if current_level.music:
			MusicManager.play(current_level.music)
	else:
		if current_level.music:
			MusicManager.stop()


func _on_enemy_death(enemy):
	remaining_enemies -= 1
	ui.set_remaining_enemies(remaining_enemies)
	score += enemy.points
	ui.set_score(score)


func _on_enemy_removed(_enemy):
	remaining_enemies_to_remove -= 1

	if remaining_enemies_to_remove == 0:
		# TODO: End game?
		level_index += 1
		GameManager.set_level_index(level_index)


func _on_level_start_timeout():
	GameManager.start_level()

	if level_index > 0:
		if current_level.music:
			MusicManager.play(current_level.music)


func _on_game_over():
	SceneManager.goto_scene("GameOver")
	MusicManager.stop()


func _on_picked_powerup(powerup: Powerup):
	print("picked up powerup", powerup)
	
	if powerup is PowerupWeapon:
		if powerup.weapon == player.current_weapon:
			player.add_bullet_count(10)
		else:
			player.set_weapon(powerup.weapon)

	if powerup is PowerupAutofire:
		player.set_autofire(powerup.autofire)

	if powerup is PowerupExtraBullet:
		player.add_bullet_count(powerup.bullet_count)

	if powerup is PowerupExtraSpeed:
		player.add_speed(powerup.speed)
