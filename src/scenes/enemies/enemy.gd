extends KinematicBody2D

var speed := 200
var direction = Vector2(0, 1)


func _ready():
	$deathAnimation/AnimatedSprite.connect(
		'animation_finished', self, '_on_death_animation_finished'
	)


func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(speed * direction * delta)

	if collision_info:
		CollisionManager.handle_collision(self, collision_info.collider)


func set_speed(new_speed: int) -> void:
	speed = new_speed


func play_death_animation() -> void:
	set_speed(0)
	$ship.visible = false
	$collision.disabled = true
	$deathAnimation.play()


func _on_death_animation_finished() -> void:
	queue_free()
