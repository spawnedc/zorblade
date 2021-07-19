extends Position2D

export var spawn_scene: PackedScene


func spawn(_spawn_scene := spawn_scene, parent_scene = self) -> Node2D:
	# Creates a new instance of the _spawn_scene
	var spawn := _spawn_scene.instance() as Node2D

	parent_scene.add_child(spawn)

	if parent_scene == self:
		# Prevents the Spawner2D transform from affecting the new instance
		spawn.set_as_toplevel(true)

	# Move the new instance to the Spawner2D position
	spawn.global_position = parent_scene.global_position

	return spawn
