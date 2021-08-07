extends Area2D

signal auto_fire_state_change(state)
signal weapon_change(weapon)
signal speed_change(speed)
signal bullet_count_change(bullet_count)
signal lives_change(lives)

onready var ship: Sprite = $ship
onready var weapon: Node2D = $weapon

# Movement speed in pixels per second.
var speed: int
var lives: int
var initial_weapon: String
var bullet_count: int
var has_autofire: bool
var current_weapon
var size: Vector2
var min_x: float
var max_x: float
var min_y: float


func _ready():
	print('Player ready')
	size = ship.get_rect().size * ship.scale.x
	min_x = size.x / 2
	max_x = get_parent().rect_size.x - min_x


func initialise() -> void:
	var defaults = Defaults.player
	set_weapon(defaults["initial_weapon"])
	set_autofire(defaults["has_autofire"])
	set_speed(defaults["speed"])
	set_bullet_count(defaults["bullet_count"])
	set_lives(defaults["lives"])


func set_lives(new_lives: int) -> void:
	lives = new_lives
	emit_signal("lives_change", lives)


func set_weapon(weapon_name: String) -> void:
	current_weapon = WeaponManager.get_weapon_data(weapon_name)
	weapon.set_weapon(current_weapon)
	print("Player: weapon_change: ", current_weapon)
	emit_signal("weapon_change", current_weapon)


func set_autofire(state: bool) -> void:
	has_autofire = state
	print("Player: auto_fire_state_change: ", has_autofire)
	emit_signal("auto_fire_state_change", has_autofire)


func set_speed(new_speed: int) -> void:
	speed = new_speed
	print("Player: speed_change: ", speed)
	emit_signal("speed_change", speed)


func set_bullet_count(new_bullet_count: int) -> void:
	bullet_count = new_bullet_count
	weapon.set_max_bullet_count(bullet_count)
	print("Player: bullet_count_change: ", bullet_count)
	emit_signal("bullet_count_change", bullet_count)


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


func _handle_weapon_fire() -> void:
	if has_autofire:
		if Input.is_action_pressed("fire"):
			weapon.fire()
	else:
		if Input.is_action_just_pressed("fire"):
			weapon.fire()


func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector = input_vector.normalized()

	position += input_vector * speed * delta

	position.x = clamp(position.x, min_x, max_x)

	_handle_weapon_keys()
	_handle_autofire()

	_handle_weapon_fire()
