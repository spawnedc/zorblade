extends Node2D


func fire():
	var children = $bulletSpawners.get_children()
	for spawner in children:
		spawner.spawn()
