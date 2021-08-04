extends Control


func _ready():
	MusicManager.play('SkyFire/Defeated (Game Over Tune)')


func _process(_delta):
	if Input.is_action_just_pressed("start_game"):
		SceneManager.goto_scene("Game")
