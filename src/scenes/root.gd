extends Node2D

onready var sceneLoader = $SceneLoader
onready var musicPlayer = $MusicPlayer


func _ready():
	SceneManager.connect("change_scene", sceneLoader, "goto_scene")
	MusicManager.connect("stop_playback", musicPlayer, "stop_music")
	MusicManager.connect("play_music", musicPlayer, "play_music")


func _unhandled_input(_event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.set_window_fullscreen(! OS.window_fullscreen)
