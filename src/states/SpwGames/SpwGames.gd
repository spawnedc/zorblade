extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout", self, "_on_timeout")
	MusicManager.play('SkyFire/SkyFire (Title Screen).ogg')


func _on_timeout():
	SceneManager.goto_scene("Title")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
