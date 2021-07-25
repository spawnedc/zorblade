extends KinematicBody2D

signal collided(bullet, collision_info)

var speed := 200
var direction = Vector2(0, -1)


func _physics_process(delta: float) -> void:
	if position.y < 0:
		queue_free()
	else:
		var collision_info = move_and_collide(speed * direction * delta)

		if collision_info:
			emit_signal("collided", self, collision_info)
