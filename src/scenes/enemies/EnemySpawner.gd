extends Node2D

onready var path: Path2D = $Path2D
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


# Called when the node enters the scene tree for the first time.
func _ready():
	max_x_position = Globals.VIEWPORT_SIZE.x - 100
	spawnTimer.connect('timeout', self, '_on_timer_timeout')
	spawnTimer.wait_time = SPAWN_RATE
	spawnTimer.start()


func _on_timer_timeout() -> void:
	var path_follow = ship_path_follow.instance()
	path.add_child(path_follow)
	path_follow.connect("reached_end", self, "_on_reached_end")

	var enemy = $spawner.spawn(enemy_scene, path_follow)
	var speed = MAX_SPEED  #randi() % (MAX_SPEED - MIN_SPEED) + MIN_SPEED
	path_follow.set_speed(speed)

	enemy.add_to_group(Globals.GROUP_ENEMY)
	enemy.set_speed(speed)
	enemy.rotation_degrees = -90
	enemy.global_position = path.position
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
