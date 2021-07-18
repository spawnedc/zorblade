extends Node

signal change_scene(scene_name)


func goto_scene(scene_name: String):
	emit_signal("change_scene", scene_name)
