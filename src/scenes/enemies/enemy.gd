extends Area2D

signal dead
signal ready_to_be_removed

const FRICTION = 20
var speed: float = 200
var health: float
var direction = Vector2(0, 1)
var final_position: Vector2
var velocity: Vector2 = Vector2.ZERO
var can_move_to_final_position: bool = false
var is_dead: bool = false
var points: int

@onready var animationPlayer = $AnimationPlayer


func _ready():
	$deathAnimation/AnimatedSprite2D.connect(
		'animation_finished', Callable(self, '_on_death_animation_finished')
	)


func _physics_process(delta: float) -> void:
	if can_move_to_final_position:
		var current_pos = global_position
		var vector = final_position - current_pos
		var length = vector.length()

		if length <= 0:
			velocity = Vector2(0, 0)
		else:
			velocity = vector * speed * delta

		global_rotation_degrees = 0

		global_position += velocity * delta


func set_texture(texture: String, scale: float):
	$ship.texture = load("res://assets/" + texture)
	$collision.shape.set_radius($ship.texture.get_width() * scale)
	$collision.scale = Vector2(scale, scale)
	$ship.scale = Vector2(scale, scale)


func set_velocity(new_speed: float) -> void:
	speed = new_speed


func set_health(new_health: float) -> void:
	health = new_health


func set_final_position(pos: Vector2):
	final_position = pos


func set_points(new_points: int):
	points = new_points


func move_to_final_position():
	can_move_to_final_position = true


func hurt(damage: float):
	if not is_dead:
		health -= damage

		if health <= 0:
			is_dead = true
			play_death_animation()
		else:
			animationPlayer.play("hurt")


func play_death_animation() -> void:
	$collision.set_deferred("disabled", true)
	$ship.visible = false
	set_velocity(0)
	$deathAnimation.play()
	emit_signal("dead")


func _on_death_animation_finished() -> void:
	# queue_free()
	emit_signal("ready_to_be_removed")
