extends Node2D


func fire():
	var children = $bulletSpawners.get_children()
	for spawner in children:
		var bullet = spawner.spawn()
		bullet.add_to_group(Globals.GROUP_PLAYER_BULLET)

	$AudioStreamPlayer.play()
