extends Node

const weapons_data_dir = "res://data/weapons"

var weapons: Dictionary = {}

func _ready():
	weapons = _get_weapons()

func _get_weapons():
	var weapon_list: Dictionary = {}
	for file in DirAccess.get_files_at(weapons_data_dir):
		var resource_file = weapons_data_dir + "/" + file
		var weapon: Weapon = load(resource_file) as Weapon
		weapon_list[weapon.name] = weapon
	
	return weapon_list

func get_weapon_data(weapon_name: String) -> Weapon:
	return weapons[weapon_name]
