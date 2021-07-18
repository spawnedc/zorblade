extends Node2D


func _ready():
	SceneManager.connect("change_scene", $SceneLoader, "gotoScene")
