extends Node2D

onready var audioPlayer = $AudioStreamPlayer
var damage: float


func set_damage(dmg: float):
	damage = dmg


func fire():
	var children = $bulletSpawners.get_children()
	for spawner in children:
		var bullet = spawner.spawn()
		bullet.connect("collided", self, "_on_bullet_collided")
		bullet.add_to_group(Globals.GROUP_PLAYER_BULLET)

	audioPlayer.play()


func _on_bullet_collided(bullet, collision_info: KinematicCollision2D):
	CollisionManager.handle_collision(bullet, collision_info.collider, damage)
