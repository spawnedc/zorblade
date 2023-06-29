extends Marker2D

@export var spawn_scene: PackedScene


func spawn(_spawn_scene, parent_scene = self) -> Node2D:
	var scene_to_spawn = _spawn_scene

	if scene_to_spawn == null:
		scene_to_spawn = spawn_scene

	# Creates a new instance of the _spawn_scene
	var spawn := scene_to_spawn.instantiate() as Node2D

	parent_scene.add_child(spawn)

	# Prevents the Spawner2D transform from affecting the new instance
	spawn.set_as_top_level(true)

	# Move the new instance to the Spawner2D position
	spawn.global_position = parent_scene.global_position

	return spawn
