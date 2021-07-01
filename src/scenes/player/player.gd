extends KinematicBody2D

# Movement speed in pixels per second.
var speed := 300
export var current_weapon: String = 'Quad Shot'


func _ready():
	$weapon.set_weapon(current_weapon)


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
		$weapon.fire()
