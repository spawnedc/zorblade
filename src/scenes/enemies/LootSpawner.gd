extends Node2D

const powerups = [
	{"name": "SingleShot", "weapon": "Single Shot"},
	{"name": "DoubleShot", "weapon": "Double Shot"},
	{"name": "TripleShot", "weapon": "Triple Shot"},
	{"name": "QuadShot", "weapon": "Quad Shot"},
	{"name": "AutoFire", "autofire": true}
]
const drop_rate = 25  # percent

onready var spawner = $spawner


func _ready():
	randomize()
	GameManager.connect("enemy_death", self, "_on_enemy_death")


func _on_enemy_death(enemy):
	var should_drop = (randi() % 99 + 1) < drop_rate

	if should_drop:
		# var index = randi() % (len(powerups) - 1)
		var powerup_data = powerups[1]
		var powerup_scene = load('res://scenes/powerups/' + powerup_data["name"] + '.tscn')

		var powerup = spawner.spawn(powerup_scene)
		powerup.global_position = enemy.global_position
		powerup.set_powerup_data(powerup_data)
		powerup.connect("collided", self, "_on_powerup_collision", [powerup_data])


func _on_powerup_collision(powerup, powerup_data):
	powerup.queue_free()
	GameManager.picked_powerup(powerup_data)
