extends Node


func handle_collision(source: KinematicBody2D, collider: KinematicBody2D):
	var isSourceEnemy = source.is_in_group(Globals.GROUP_ENEMY)
	var isColliderPlayerBullet = collider.is_in_group(Globals.GROUP_PLAYER_BULLET)

	if isSourceEnemy and isColliderPlayerBullet:
		source.queue_free()
		collider.queue_free()
