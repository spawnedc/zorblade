extends KinematicBody2D

# Movement speed in pixels per second.
var speed := 300
export var current_weapon: String = 'Single Shot'


func _ready():
	WeaponManager.set_weapon(current_weapon)


func _handle_weapon_keys() -> void:
	var new_weapon

	if Input.is_action_just_pressed("weapon_single_shot"):
		new_weapon = 'Single Shot'

	if Input.is_action_just_pressed("weapon_double_shot"):
		new_weapon = 'Double Shot'

	if Input.is_action_just_pressed("weapon_triple_shot"):
		new_weapon = 'Triple Shot'

	if Input.is_action_just_pressed("weapon_quad_shot"):
		new_weapon = 'Quad Shot'

	if new_weapon:
		WeaponManager.set_weapon(new_weapon)


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

	_handle_weapon_keys()

	if Input.is_action_pressed("fire"):
		$weapon.fire()
