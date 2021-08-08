class_name LevelPath

var num_enemies: int
var spawn_rate: float
var spawn_delay: float
var points: PoolVector2Array = []
var final_positions: PoolVector2Array = []
var curve_smoothness: int = 0
var loop: bool = false
var rotate: bool = true


func add_point(point: Vector2):
	points.append(point)


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


func to_json() -> Dictionary:
	var points_array = []

	for point in points:
		points_array.append({"x": point.x, "y": point.y})

	var final_positions_array = []

	for point in final_positions:
		final_positions_array.append({"x": point.x, "y": point.y})

	var path_data: Dictionary = {
		"num_enemies": num_enemies,
		"spawn_rate": spawn_rate,
		"spawn_delay": spawn_delay,
		"curve_smoothness": curve_smoothness,
		"loop": loop,
		"rotate": rotate,
		"points": points_array,
		"final_positions": final_positions_array
	}

	return path_data
