extends Area2D

signal auto_fire_state_change(state)
signal weapon_change(weapon)

const ACCELERATION = 2500
const MAX_SPEED = 400
const FRICTION = 2500

onready var ship = $ship

var velocity = Vector2.ZERO

# Movement speed in pixels per second.
var speed: int = 300
var initial_weapon: String = 'Single Shot'
var current_weapon
var has_autofire: bool = false
var size
var min_x
var max_x
var min_y
var max_y


func _ready():
	print('Player ready')
	size = ship.get_rect().size * ship.scale.x
	min_x = size.x / 2
	max_x = get_parent().rect_size.x - min_x
	min_y = size.y / 2
	max_y = get_parent().rect_size.y - min_y


func initialise():
	set_weapon(initial_weapon)
	set_autofire(has_autofire)


func set_weapon(weapon_name: String):
	current_weapon = WeaponManager.get_weapon_data(weapon_name)
	$weapon.set_weapon(current_weapon)
	emit_signal("weapon_change", current_weapon)


func set_autofire(state: bool):
	has_autofire = state
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
		set_weapon(new_weapon)


func _handle_autofire() -> void:
	if Input.is_action_just_pressed("toggle_autofire"):
		set_autofire(! has_autofire)


func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	position += velocity * delta

	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)

	_handle_weapon_keys()
	_handle_autofire()

	if has_autofire:
		if Input.is_action_pressed("fire"):
			$weapon.fire()
	else:
		if Input.is_action_just_pressed("fire"):
			$weapon.fire()
