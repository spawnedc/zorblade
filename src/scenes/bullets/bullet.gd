extends KinematicBody2D

var speed := 500
var direction = Vector2(0, -1)


func _physics_process(_delta: float) -> void:
	move_and_slide(speed * direction)
