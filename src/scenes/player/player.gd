extends KinematicBody2D

# Movement speed in pixels per second.
var speed := 300
# Bullets per second
var fireRate = 0.5
# Internal time to control fire rate.
# Starting off from fireRate to allow shooting on first key press.
var fireTimer = fireRate


func _physics_process(_delta: float) -> void:
	if global_position.y < 0:
		queue_free()

	# Once again, we call `Input.get_action_strength()` to support analog movement.
	var direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	# When aiming the joystick diagonally, the direction vector can have a length
	# greater than 1.0, making the character move faster than our maximum expected
	# speed. When that happens, we limit the vector's length to ensure the player
	# can't go beyond the maximum speed.
	if direction.length() > 1.0:
		direction = direction.normalized()

	move_and_slide(speed * direction)

	if Input.is_action_pressed("fire"):
		fireTimer += _delta
		if fireTimer > fireRate:
			fireTimer = 0
			$bulletSpawner.spawn()
