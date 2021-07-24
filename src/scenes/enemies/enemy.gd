extends KinematicBody2D

signal dead(enemy)

const FRICTION = 20
var speed := 200
var direction = Vector2(0, 1)
var final_position: Vector2
var velocity: Vector2 = Vector2.ZERO
var can_move_to_final_position: bool = false


func _ready():
	$deathAnimation/AnimatedSprite.connect(
		'animation_finished', self, '_on_death_animation_finished'
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

		move_and_slide(velocity)


func set_speed(new_speed: int) -> void:
	speed = new_speed


func set_final_position(pos: Vector2):
	final_position = pos


func move_to_final_position():
	can_move_to_final_position = true


func play_death_animation() -> void:
	emit_signal("dead", self)
	set_speed(0)
	$ship.visible = false
	$collision.disabled = true
	$deathAnimation.play()


func _on_death_animation_finished() -> void:
	queue_free()
