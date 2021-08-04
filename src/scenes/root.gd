extends Node2D

onready var sceneLoader = $SceneLoader
onready var musicPlayer = $MusicPlayer


func _ready():
	SceneManager.connect("change_scene", sceneLoader, "goto_scene")
	MusicManager.connect("stop_playback", musicPlayer, "stop_music")
	MusicManager.connect("play_music", musicPlayer, "play_music")
	# musicPlayer.play_music('SkyFire/SkyFire (Title Screen)')
