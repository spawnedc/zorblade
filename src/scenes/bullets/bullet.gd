extends Area2D

var speed := 200
var direction = Vector2(0, -1)


func _physics_process(delta: float) -> void:
	if position.y < 0:
		queue_free()
	else:
		position += speed * direction * delta
