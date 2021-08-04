extends Object

var sprite: String
var health: float
var speed: float
var scale: float = 0.4


func _init(enemy_data):
	sprite = enemy_data["sprite"]
	health = enemy_data["health"]
	speed = enemy_data["speed"]

	if "scale" in enemy_data:
		scale = enemy_data["scale"]
