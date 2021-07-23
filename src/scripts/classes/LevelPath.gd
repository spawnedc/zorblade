extends Object

var num_enemies: int
var spawn_rate: float
var spawn_delay: float
var points: PoolVector2Array = []
var final_positions: PoolVector2Array = []


func _init(path_data: Dictionary):
	num_enemies = path_data["num_enemies"]
	spawn_rate = path_data["spawn_rate"]
	spawn_delay = path_data["spawn_delay"]

	for point in path_data["points"]:
		points.append(Vector2(point["x"], point["y"]))

	for final_position in path_data["final_positions"]:
		final_positions.append(Vector2(final_position["x"], final_position["y"]))
