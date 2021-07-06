extends KinematicBody2D

signal collided(entitiy, collision_info)

var speed := 2
var direction = Vector2(0, 1)


func _physics_process(_delta: float) -> void:
	var collision_info = move_and_collide(speed * direction)

	if collision_info:
		emit_signal('collided', self, collision_info)
