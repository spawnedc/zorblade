extends PathFollow2D

signal reached_end(enemy)

var reached_end: bool = false
var speed: int = 200


func _process(delta: float) -> void:
	if not reached_end:
		if unit_offset == 1:
			reached_end = true
			emit_signal("reached_end", get_child(0))
		else:
			offset += speed * delta


func set_speed(new_speed: int):
	speed = new_speed
