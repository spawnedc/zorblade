extends KinematicBody2D

signal auto_fire_state_change(state)

const ACCELERATION = 2500
const MAX_SPEED = 400
const FRICTION = 2500

var velocity = Vector2.ZERO

# Movement speed in pixels per second.
var speed := 300
var current_weapon: String = 'Single Shot'
var has_autofire: bool = false


func _ready():
	WeaponManager.set_weapon(current_weapon)
	emit_signal("auto_fire_state_change", has_autofire)


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


func _handle_autofire() -> void:
	if Input.is_action_just_pressed("toggle_autofire"):
		has_autofire = ! has_autofire
		emit_signal("auto_fire_state_change", has_autofire)


func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)

	_handle_weapon_keys()
	_handle_autofire()

	if has_autofire:
		if Input.is_action_pressed("fire"):
			$weapon.fire()
	else:
		if Input.is_action_just_pressed("fire"):
			$weapon.fire()
