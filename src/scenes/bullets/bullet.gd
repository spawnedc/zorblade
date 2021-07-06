extends KinematicBody2D

var speed := 5
var direction = Vector2(0, -1)


func _physics_process(_delta: float) -> void:
	move_and_collide(speed * direction)
