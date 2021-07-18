extends Node2D

onready var player = $player
onready var ui = $UI


func _ready():
	player.connect("auto_fire_state_change", ui, "_set_auto_fire_state")
	WeaponManager.connect("weapon_change", ui, "_set_weapon")

	ui._set_auto_fire_state(player.has_autofire)
	ui._set_weapon(WeaponManager.weapon_data)
