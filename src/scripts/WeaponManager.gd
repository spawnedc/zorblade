extends Node

signal weapon_change(weapon_data)

var weapon_data


func _get_weapon_data(weapon_name: String):
	return WeaponsData.weapons[weapon_name]


func set_weapon(weapon_name: String):
	weapon_data = _get_weapon_data(weapon_name)
	emit_signal('weapon_change', weapon_data)
	# bullet_scene = load('res://scenes/weapons/' + weapon_data['bullet_scene'] + '.tscn')
