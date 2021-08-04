extends Control


func _process(_delta):
	if Input.is_action_just_pressed("start_game"):
		SceneManager.goto_scene("Game")
		MusicManager.stop()
