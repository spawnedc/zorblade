extends Node2D

var max_x_position: int = 0
const MIN_SPEED = 200
const MAX_SPEED = 400


# Called when the node enters the scene tree for the first time.
func _ready():
	max_x_position = Globals.VIEWPORT_SIZE.x - 100
	$spawnTimer.connect('timeout', self, '_on_timer_timeout')


func _on_timer_timeout() -> void:
	var enemy = $spawner.spawn()

	var speed = randi() % (MAX_SPEED - MIN_SPEED) + MIN_SPEED

	enemy.add_to_group(Globals.GROUP_ENEMY)
	enemy.position.x = randi() % max_x_position + 50
	enemy.set_speed(speed)

	$spawnTimer.wait_time = randi() % 2 + 1
