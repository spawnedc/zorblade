extends Node

signal scene_loaded(scene)

export (String, FILE, "*.tscn") var LEVEL_START

var current_scenes = []
onready var fader = $Fader
onready var animation_player = $Fader/AnimationPlayer
onready var scenes = $Scenes


func _ready():
	_deferred_goto_scene(LEVEL_START)


func _get_scene_name(scene_name: String) -> String:
	if scene_name.begins_with("res://"):
		return scene_name

	return 'res://states/' + scene_name + '/' + scene_name + '.tscn'


func _get_scene_instance(scene_name: String) -> Resource:
	var path = _get_scene_name(scene_name)
	var new_scene = load(path)

	return new_scene.instance()


func _show_scene(scene_name: String) -> void:
	var new_scene = _get_scene_instance(scene_name)
	scenes.add_child(new_scene)
	current_scenes.append(new_scene)

	emit_signal("scene_loaded", new_scene)


func goto_scene(scene_name: String):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	call_deferred("_deferred_goto_scene", scene_name)


func _deferred_goto_scene(scene_name: String):
	animation_player.connect("animation_finished", self, "_on_fadeout_finished", [scene_name])
	animation_player.play("Fade")


func _on_fadeout_finished(_animationName: String, scene_name: String):
	animation_player.disconnect("animation_finished", self, "_on_fadeout_finished")

	while len(current_scenes):
		var scene = current_scenes.pop_front()
		scene.free()

	_show_scene(scene_name)

	animation_player.play_backwards("Fade")
