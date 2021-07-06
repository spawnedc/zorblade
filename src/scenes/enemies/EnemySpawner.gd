extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$spawnTimer.connect('timeout', self, '_on_timer_timeout')


func _on_timer_timeout() -> void:
	var enemy = $spawner.spawn()
	enemy.connect('collided', self, '_on_enemy_collision')

	$spawnTimer.wait_time = randi() % 5 + 1


func _on_enemy_collision(entity, collision_info: KinematicCollision2D) -> void:
	collision_info.collider.queue_free()
	print(entity)
