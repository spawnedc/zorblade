extends Area2D

signal auto_fire_state_change(state)
signal weapon_change(weapon)
signal speed_change(speed)
signal bullet_count_change(bullet_count)
signal lives_change(lives)

@onready var ship: Sprite2D = $ship
@onready var weapon: Node2D = $weapon
@onready var powerup_label: Label = $PowerupName
@onready var powerup_animation: AnimationPlayer = $PowerupName/animation

# Movement speed in pixels per second.
@export var speed: int
@export var lives: int
@export var bullet_count: int
@export var has_autofire: bool
@export var current_weapon: Weapon
var size: Vector2
var min_x: float
var max_x: float
var initialised: bool = false


func _ready():
	print('Player ready')
	add_to_group(Globals.GROUP_PLAYER)
	size = ship.get_rect().size * ship.scale.x
	min_x = size.x / 2
	max_x = get_parent().size.x - min_x


func initialise() -> void:
	set_weapon(current_weapon)
	set_bullet_count(bullet_count)
	set_velocity(speed)
	set_autofire(has_autofire)
	set_lives(lives)
	initialised = true


func set_lives(new_lives: int) -> void:
	lives = new_lives
	emit_signal("lives_change", lives)


func set_weapon(new_weapon: Weapon) -> void:
	print(new_weapon)
	current_weapon = new_weapon
	weapon.set_weapon(current_weapon)
	print("Player: weapon_change: ", current_weapon)
	emit_signal("weapon_change", current_weapon)
	notify(current_weapon.name)


func set_autofire(state: bool) -> void:
	has_autofire = state
	print("Player: auto_fire_state_change: ", has_autofire)
	emit_signal("auto_fire_state_change", has_autofire)
	notify("Autofire")


func add_speed(speed_amount: int) -> void:
	set_velocity(speed + speed_amount)

func set_velocity(new_speed: int) -> void:
	speed = new_speed
	print("Player: speed_change: ", speed)
	emit_signal("speed_change", speed)
	notify("Extra speed")


func add_bullet_count(num_bullets: int) -> void:
	set_bullet_count(bullet_count + num_bullets)


func set_bullet_count(new_bullet_count: int) -> void:
	bullet_count = new_bullet_count
	weapon.set_max_bullet_count(bullet_count)
	print("Player: bullet_count_change: ", bullet_count)
	emit_signal("bullet_count_change", bullet_count)
	notify("Extra bullet")


func _handle_weapon_keys() -> void:
	var new_weapon: Weapon

	if Input.is_action_just_pressed("weapon_single_shot"):
		new_weapon = WeaponManager.get_weapon_data('Single Shot')

	if Input.is_action_just_pressed("weapon_double_shot"):
		new_weapon = WeaponManager.get_weapon_data('Double Shot')

	if Input.is_action_just_pressed("weapon_triple_shot"):
		new_weapon = WeaponManager.get_weapon_data('Triple Shot')

	if Input.is_action_just_pressed("weapon_quad_shot"):
		new_weapon = WeaponManager.get_weapon_data('Quad Shot')

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


func notify(text: String):
	if initialised:
		print("Player: notify: ", text)
		powerup_label.text = text
		powerup_animation.seek(0)
		powerup_animation.play("move_and_fade")


func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector = input_vector.normalized()

	position += input_vector * speed * delta

	position.x = clamp(position.x, min_x, max_x)

	_handle_weapon_keys()
	_handle_autofire()

	_handle_weapon_fire()
