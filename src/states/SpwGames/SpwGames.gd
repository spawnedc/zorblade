extends Node


func _ready():
	$Timer.connect("timeout", self, "_on_timeout")


func _on_timeout():
	SceneManager.goto_scene("Title")
