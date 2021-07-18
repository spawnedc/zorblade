extends Control

onready var auto_fire_value = $MarginContainer/VBoxContainer/Autofire/Value
onready var weapon_value = $MarginContainer/VBoxContainer/CurrentWeapon/Value


func _set_auto_fire_state(state: bool):
	if state == true:
		auto_fire_value.text = "On"
	else:
		auto_fire_value.text = "Off"


func _set_weapon(weapon_data):
	weapon_value.text = weapon_data['name']
