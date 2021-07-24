extends Control

onready var auto_fire_value = $MarginContainer/VBoxContainer/Autofire/Value
onready var weapon_value = $MarginContainer/VBoxContainer/CurrentWeapon/Value
onready var level_name = $MarginContainer/VBoxContainer/CurrentLevel/Value
onready var remaining_enemies = $MarginContainer/VBoxContainer/RemainingEnemies/Value


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


func set_remaining_enemies(count: int):
	remaining_enemies.text = String(count)
