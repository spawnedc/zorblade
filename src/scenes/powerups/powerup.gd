extends Area2D

onready var collision = $collision

var speed: int = 50
var direction: Vector2 = Vector2(0, 1)
var powerup_data: Dictionary


func set_powerup_data(data: Dictionary):
	powerup_data = data


func _physics_process(delta: float) -> void:
	if position.y > Globals.VIEWPORT_HEIGHT:
		print('Powerup: Remove from scene')
		queue_free()
	else:
		position += speed * direction * delta
