class_name LevelPath

var num_enemies: int
var spawn_rate: float
var spawn_delay: float
var points: PoolVector2Array = []
var final_positions: PoolVector2Array = []
var curve_smoothness: int
var loop: bool = false
var rotate: bool = true


func set_path_data(path_data: Dictionary):
	num_enemies = path_data["num_enemies"]
	spawn_rate = path_data["spawn_rate"]
	spawn_delay = path_data["spawn_delay"]
	curve_smoothness = path_data["curve_smoothness"]

	if "loop" in path_data:
		loop = path_data["loop"]

	if "rotate" in path_data:
		rotate = path_data["rotate"]

	for point in path_data["points"]:
		points.append(Vector2(point["x"], point["y"]))

	for final_position in path_data["final_positions"]:
		final_positions.append(Vector2(final_position["x"], final_position["y"]))
