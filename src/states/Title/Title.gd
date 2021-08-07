extends Control

onready var btn_new_game: TextureButton = $Wrapper/MenuContainer/Menu/NewGame/Button
onready var btn_editor: TextureButton = $Wrapper/MenuContainer/Menu/Editor/Button
onready var btn_quit: TextureButton = $Wrapper/MenuContainer/Menu/Quit/Button


func _ready():
	btn_new_game.connect("button_up", self, "start_new_game")
	btn_editor.connect("button_up", self, "start_editor")
	btn_quit.connect("button_up", self, "quit_game")


func start_new_game():
	SceneManager.goto_scene("Game")
	MusicManager.stop()


func start_editor():
	SceneManager.goto_scene("Editor")
	MusicManager.stop()


func quit_game():
	get_tree().quit()
