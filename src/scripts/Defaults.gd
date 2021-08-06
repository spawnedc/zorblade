extends Node

var player: Dictionary


func _ready():
	var file = File.new()
	file.open("res://data/defaults.json", file.READ)
	var text = file.get_as_text()
	file.close()

	var defaults: Dictionary = JSON.parse(text).result

	player = defaults["player"]
