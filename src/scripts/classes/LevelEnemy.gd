class_name LevelEnemy

var sprite: String
var health: float
var speed: float
var points: int
var scale: float = 0.4


func set_enemy_data(enemy_data):
	sprite = enemy_data["sprite"]
	health = enemy_data["health"]
	speed = enemy_data["speed"]
	points = enemy_data["points"]

	if "scale" in enemy_data:
		scale = enemy_data["scale"]


func to_json() -> Dictionary:
	var enemy_data: Dictionary = {
		"sprite": sprite,
		"health": health,
		"speed": speed,
		"points": points,
		"scale": scale,
	}

	return enemy_data
