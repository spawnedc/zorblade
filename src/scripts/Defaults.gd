extends Node

var player: Dictionary


func _ready():
	var defaults: Dictionary = Utils.load_json("defaults")

	player = defaults["player"]
