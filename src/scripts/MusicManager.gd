extends Node

signal stop_playback
signal play_music(name)


func stop():
	emit_signal("stop_playback")

func play(name: String):
	emit_signal("play_music", name)
