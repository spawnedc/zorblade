extends Object

var sprite: String
var health: float
var speed: float
var points: int
var scale: float = 0.4


func _init(enemy_data):
	sprite = enemy_data["sprite"]
	health = enemy_data["health"]
	speed = enemy_data["speed"]
	points = enemy_data["points"]

	if "scale" in enemy_data:
		scale = enemy_data["scale"]
