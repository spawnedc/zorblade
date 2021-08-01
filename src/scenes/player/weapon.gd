extends Node2D

var fire_rate = 0
# Internal time to control fire rate.
# Starting off from fire_rate to allow shooting on first key press.
var fire_timer = 0
var can_fire = true
var current_weapon


func _get_weapon_instance(scene_name: String) -> Resource:
	var weapon_scene = load('res://scenes/weapons/' + scene_name + '.tscn')

	return weapon_scene.instance()


func fire():
	if can_fire:
		current_weapon.fire(self)
		can_fire = false
		fire_timer = 0


func _physics_process(_delta):
	fire_timer += _delta
	if fire_timer > fire_rate:
		fire_timer = 0
		can_fire = true


func set_weapon(weapon_data):
	if current_weapon:
		current_weapon.queue_free()

	current_weapon = _get_weapon_instance(weapon_data['bullet_scene'])
	current_weapon.set_damage(weapon_data["damage"])
	fire_rate = weapon_data['fire_rate']

	add_child(current_weapon)
