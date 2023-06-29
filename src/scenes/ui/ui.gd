extends Control

@onready var debug_ui = $DebugUI

@onready var auto_fire_value = $DebugUI/VBoxContainer/Autofire/Value
@onready var weapon_value = $DebugUI/VBoxContainer/CurrentWeapon/Value
@onready var level_name = $DebugUI/VBoxContainer/CurrentLevel/Value
@onready var remaining_enemies = $DebugUI/VBoxContainer/RemainingEnemies/Value

@onready var speed_bar: ProgressBar = $ActualUI/UiContainer/Speed/Bar
@onready var bullets_bar: ProgressBar = $ActualUI/UiContainer/Bullet/Bar
@onready var level_info: Label = $ActualUI/UiContainer/LevelInfo
@onready var player_lives: TextureProgressBar = $ActualUI/UiContainer/Lives/Lives
@onready var score_label: Label = $ScoreContainer/Value


func _ready():
	if Globals.IS_DEBUG == false:
		debug_ui.visible = false


func set_auto_fire_state(state: bool):
	if state == true:
		auto_fire_value.text = "On"
	else:
		auto_fire_value.text = "Off"


func set_weapon(weapon_data):
	weapon_value.text = weapon_data['name']


func set_level(level: Level):
	set_remaining_enemies(level.total_enemies)
	set_level_name(level.name)


func set_level_name(name: String):
	level_name.text = name
	level_info.text = name


func set_remaining_enemies(count: int):
	remaining_enemies.text = str(count)


func set_velocity(speed: int):
	speed_bar.value = speed


func set_bullet_count(bullet_count: int):
	bullets_bar.value = bullet_count


func set_lives(lives: int):
	player_lives.value = lives


func set_score(score: int):
	score_label.text = Utils.format_number(score)
