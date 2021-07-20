extends Node2D

onready var dynamic_path: Path2D = $dynamicPath
onready var dynamic_paths: Node2D = $dynamicPaths
onready var spawnTimer: Timer = $spawnTimer

const MIN_SPEED = 200
const MAX_SPEED = 400
const SPAWN_RATE = 0.5

var enemy_scene = preload('res://scenes/enemies/EnemyBlack.tscn')
var ship_path_follow = preload('res://scenes/enemies/ShipPathFollow.tscn')

var timer_call_counts = Array()


func array_to_curve(input: Array, dist: float = 0) -> Curve2D:
	#dist determines length of controls, set dist = 0 for no smoothing
	var curve = Curve2D.new()

	#calculate first point
	var start_dir = input[0].direction_to(input[1])
	curve.add_point(input[0], -start_dir * dist, start_dir * dist)

	#calculate middle points
	for i in range(1, input.size() - 1):
		var dir = input[i - 1].direction_to(input[i + 1])
		curve.add_point(input[i], -dir * dist, dir * dist)

	#calculate last point
	var end_dir = input[-1].direction_to(input[-2])
	curve.add_point(input[-1], -end_dir, end_dir)

	return curve


func _create_paths(level_data: Dictionary):
	var paths = level_data["paths"]

	for index in len(paths):
		timer_call_counts.append(0)
		var path = paths[index]
		var path_2d: Path2D = Path2D.new()
		var curve_points = Array()

		for point in path["points"]:
			curve_points.append(Vector2(point["x"], point["y"]))

		var curve: Curve2D = array_to_curve(curve_points, 100)
		var start_point = curve_points[0]

		path_2d.curve = curve

		dynamic_paths.add_child(path_2d)

		var timer: Timer = Timer.new()
		timer.autostart = false
		timer.one_shot = true
		timer.wait_time = SPAWN_RATE  # TODO: read this from level data
		timer.connect(
			"timeout", self, "_on_path_timer_timeout", [timer, path_2d, start_point, index]
		)

		dynamic_paths.add_child(timer)

		timer.start()


func _on_path_timer_timeout(timer, path_2d, start_point, path_index) -> void:
	print(start_point)
	var speed = MAX_SPEED
	var path_follow = ship_path_follow.instance()
	var enemy = $spawner.spawn(enemy_scene, path_follow)
	var enemy_index = timer_call_counts[path_index]
	var final_position = GameManager.get_final_position(path_index, enemy_index)
	print(final_position)

	path_follow.set_speed(speed)
	path_follow.connect("reached_end", self, "_on_enemy_reached_path_end", [enemy])

	path_2d.add_child(path_follow)

	enemy.add_to_group(Globals.GROUP_ENEMY)
	enemy.set_speed(speed)
	enemy.global_rotation_degrees = 0
	enemy.global_position = start_point
	enemy.set_final_position(final_position)
	enemy.connect("dead", self, "_on_enemy_dead")

	timer_call_counts[path_index] += 1

	var enemy_count = timer_call_counts[path_index]

	if enemy_count < GameManager.get_max_enemies(path_index):
		timer.start()


func _on_enemy_reached_path_end(enemy) -> void:
	enemy.move_to_final_position()


func _ready():
	var level_data = GameManager.set_level(1)
	_create_paths(level_data)


func _on_reached_end(enemy):
	enemy.move_to_final_position()


func _on_enemy_dead(enemy):
	enemy.get_parent().set_speed(0)
