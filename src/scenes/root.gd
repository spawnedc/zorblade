extends Node2D

@onready var sceneLoader = $SceneLoader
@onready var musicPlayer = $MusicPlayer


func _ready():
	SceneManager.connect("change_scene_to_file", Callable(sceneLoader, "goto_scene"))
	MusicManager.connect("stop_playback", Callable(musicPlayer, "stop_music"))
	MusicManager.connect("play_music", Callable(musicPlayer, "play_music"))


func _unhandled_input(_event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (! ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
