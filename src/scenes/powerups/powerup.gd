extends KinematicBody2D

signal collided(powerup)

onready var collision = $collision

var speed: int = 50
var direction: Vector2 = Vector2(0, 1)
var powerup_data: Dictionary


func set_powerup_data(data: Dictionary):
	powerup_data = data


func _physics_process(delta: float) -> void:
	if position.y < 0:
		queue_free()
	else:
		var collision_info = move_and_collide(speed * direction * delta)

		if collision_info:
			collision.disabled = true
			emit_signal("collided", self)
