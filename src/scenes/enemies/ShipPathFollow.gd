extends PathFollow2D

signal reached_end(enemy)

var has_reached_end: bool = false
var speed: int = 200


func _process(delta: float) -> void:
	if not has_reached_end:
		if progress_ratio == 1:
			has_reached_end = true
			emit_signal("reached_end")
		else:
			progress += speed * delta


func set_velocity(new_speed: int):
	speed = new_speed
