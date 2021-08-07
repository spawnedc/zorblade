extends Node


func handle_bullet_hit_enemy(enemy: Area2D, bullet: Area2D, damage: float):
	bullet.queue_free()
	enemy.hurt(damage)


func handle_player_picked_up_powerup(_player: Area2D, powerup: Area2D, powerup_data: Dictionary):
	if _player.is_in_group(Globals.GROUP_PLAYER):
		powerup.queue_free()
		GameManager.picked_powerup(powerup_data)
