extends Node


func handle_collision(source: KinematicBody2D, collider: KinematicBody2D):
	var isSourcePlayerBullet = source.is_in_group(Globals.GROUP_PLAYER_BULLET)
	var isColliderEnemy = collider.is_in_group(Globals.GROUP_ENEMY)

	if isSourcePlayerBullet and isColliderEnemy:
		collider.play_death_animation()
		source.queue_free()
