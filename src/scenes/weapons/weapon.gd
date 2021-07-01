extends Node2D

var fireRate = 0
# Internal time to control fire rate.
# Starting off from fireRate to allow shooting on first key press.
var fireTimer = 0

var weapon_data

var bullet_scene: PackedScene

var canFire = true


func set_weapon(weapon_name: String):
	weapon_data = WeaponsData.weapons[weapon_name]
	fireTimer = weapon_data['fire_rate']
	fireRate = weapon_data['fire_rate']
	bullet_scene = load('res://scenes/weapons/' + weapon_data['bullet_scene'] + '.tscn')
	print('res://scenes/weapons/' + weapon_data['bullet_scene'] + '.tscn')


func _get_weapon_data(weapon_name: String):
	return WeaponsData.weapons[weapon_name]


func fire():
	if canFire:
		print('firing ' + weapon_data['name'])
		$bulletSpawner.spawn(bullet_scene)


func _physics_process(_delta):
	fireTimer += _delta
	if fireTimer > fireRate:
		fireTimer = 0
		canFire = true
	else:
		canFire = false
