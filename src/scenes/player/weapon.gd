extends Node2D

var fire_rate = 0
# Internal time to control fire rate.
# Starting off from fire_rate to allow shooting on first key press.
var fire_timer = 0
var can_fire = true
var current_weapon


func _ready():
	WeaponManager.connect("weapon_change", self, "_on_weapon_change")


func _get_scene_name(scene_name: String) -> String:
	if scene_name.begins_with("res://"):
		return scene_name

	return 'res://scenes/weapons/' + scene_name + '.tscn'


func _get_weapon_instance(scene_name: String) -> Resource:
	var path = _get_scene_name(scene_name)
	var weapon_scene = load(path)

	return weapon_scene.instance()


func fire():
	if can_fire:
		current_weapon.fire()
		can_fire = false
		fire_timer = 0


func _physics_process(_delta):
	fire_timer += _delta
	if fire_timer > fire_rate:
		fire_timer = 0
		can_fire = true


func _on_weapon_change(weapon_data):
	print('weapon change ' + weapon_data['name'])
	if current_weapon:
		current_weapon.queue_free()

	current_weapon = _get_weapon_instance(weapon_data['bullet_scene'])
	fire_rate = weapon_data['fire_rate']

	add_child(current_weapon)
