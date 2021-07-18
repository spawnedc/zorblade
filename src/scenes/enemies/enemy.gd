extends KinematicBody2D

var speed := 2
var direction = Vector2(0, 1)


func _ready():
	$deathAnimation/AnimatedSprite.connect(
		'animation_finished', self, '_on_death_animation_finished'
	)


func _physics_process(_delta: float) -> void:
	var collision_info = move_and_collide(speed * direction)

	if collision_info:
		CollisionManager.handle_collision(self, collision_info.collider)


func play_death_animation() -> void:
	speed = 0
	$ship.visible = false
	$collision.disabled = true
	$deathAnimation.play()


func _on_death_animation_finished() -> void:
	queue_free()
