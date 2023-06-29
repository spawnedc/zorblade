extends Node

signal change_scene_to_file(scene_name)


func goto_scene(scene_name: String):
	emit_signal("change_scene_to_file", scene_name)
