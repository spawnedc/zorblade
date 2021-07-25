extends Object

var sprite: String
var health: float
var speed: float


func _init(enemy_data):
	sprite = enemy_data["sprite"]
	health = enemy_data["health"]
	speed = enemy_data["speed"]
