extends Node2D

onready var audioPlayer = $AudioStreamPlayer
var damage: float


func set_damage(dmg: float):
	damage = dmg


func fire(parent_scene):
	var children = $bulletSpawners.get_children()
	for spawner in children:
		var bullet = spawner.spawn(null, parent_scene)
		bullet.global_position = spawner.global_position
		bullet.add_to_group(Globals.GROUP_PLAYER_BULLET)
		bullet.connect(
			"area_entered", CollisionManager, "handle_bullet_hit_enemy", [bullet, damage]
		)

	audioPlayer.play()
