extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$spawnTimer.connect('timeout', self, '_on_timer_timeout')


func _on_timer_timeout() -> void:
	var enemy = $spawner.spawn()
	enemy.add_to_group(Globals.GROUP_ENEMY)

	$spawnTimer.wait_time = randi() % 5 + 1
