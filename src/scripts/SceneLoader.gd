extends Node

signal scene_loaded(scene)

export (String, FILE, "*.tscn") var LEVEL_START

var currentScenes = []


func _ready():
	_deferredGotoScene(LEVEL_START)


func _getSceneName(sceneName: String) -> String:
	if sceneName.begins_with("res://"):
		return sceneName

	return 'res://states/' + sceneName + '/' + sceneName + '.tscn'


func _getSceneInstance(sceneName: String) -> Resource:
	var path = _getSceneName(sceneName)
	var newScene = load(path)

	return newScene.instance()


func showScene(sceneName: String) -> Resource:
	var newScene = _getSceneInstance(sceneName)
	$Scenes.add_child(newScene)
	emit_signal("scene_loaded", newScene)
	currentScenes.append(newScene)

	return newScene


func gotoScene(sceneName: String):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	call_deferred("_deferredGotoScene", sceneName)


func _deferredGotoScene(sceneName: String):
	$Fader/AnimationPlayer.connect("animation_finished", self, "_onFadeOutFinished", [sceneName])
	$Fader/AnimationPlayer.play("Fade")


func _onFadeOutFinished(_animationName: String, sceneName: String):
	$Fader/AnimationPlayer.disconnect("animation_finished", self, "_onFadeOutFinished")

	while len(currentScenes):
		var scene = currentScenes.pop_front()
		scene.free()

	showScene(sceneName)

	$Fader/AnimationPlayer.play_backwards("Fade")
