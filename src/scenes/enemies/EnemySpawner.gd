extends Node2D

onready var dynamic_path: Path2D = $dynamicPath
onready var spawnTimer: Timer = $spawnTimer

var max_x_position: int = 0
const MIN_SPEED = 200
const MAX_SPEED = 400
const MAX_ENEMIES = 20
const SPAWN_RATE = 0.5
var current_row = 0
var current_column = 0

var enemy_scene = preload('res://scenes/enemies/EnemyBlack.tscn')
var ship_path_follow = preload('res://scenes/enemies/ShipPathFollow.tscn')
var enemy_count: int = 0
var enemy_start_point: Vector2
var enemy_path_follow


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


# Called when the node enters the scene tree for the first time.
func _ready():
	var curve_points = [
		Vector2(100, -50),
		Vector2(100, 500),
		Vector2(200, 500),
		Vector2(200, 100),
	]
	var curve: Curve2D = array_to_curve(curve_points, 100)
	enemy_start_point = curve_points[0]

	dynamic_path.curve = curve
	max_x_position = Globals.VIEWPORT_SIZE.x - 100
	spawnTimer.connect('timeout', self, '_on_timer_timeout')
	spawnTimer.wait_time = SPAWN_RATE
	spawnTimer.start()


func _on_timer_timeout() -> void:
	enemy_path_follow = ship_path_follow.instance()
	dynamic_path.add_child(enemy_path_follow)
	enemy_path_follow.connect("reached_end", self, "_on_reached_end")

	var enemy = $spawner.spawn(enemy_scene, enemy_path_follow)
	var speed = MAX_SPEED
	enemy_path_follow.set_speed(speed)

	enemy.add_to_group(Globals.GROUP_ENEMY)
	enemy.set_speed(speed)
	enemy.global_rotation_degrees = 0
	enemy.global_position = enemy_start_point
	enemy.connect("dead", self, "_on_enemy_dead")

	var row: int = enemy_count / 5

	if row != current_row:
		current_row = row
		current_column = 0
	else:
		current_column = enemy_count % 5

	var x_pos = 400 - (current_column * 50)
	var y_pos = 100 + (current_row * 50)
	var final_position: Vector2 = Vector2(x_pos, y_pos)
	enemy.set_final_position(final_position)

	enemy_count += 1

	if enemy_count < MAX_ENEMIES:
		spawnTimer.start()


func _on_reached_end(enemy):
	enemy.move_to_final_position()


func _on_enemy_dead(enemy):
	enemy.get_parent().set_speed(0)
