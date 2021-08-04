extends Node

onready var player: AudioStreamPlayer = $Player
onready var fader: AnimationPlayer = $Player/Fader


func _get_music_name(music_name: String) -> String:
	if music_name.begins_with("res://"):
		return music_name

	return 'res://assets/music/' + music_name + '.ogg'


func stop_music(immediate: bool = false):
	if immediate == false:
		fader.connect('animation_finished', self, '_stop_playback')
		fader.play('fade')
	else:
		_stop_playback()


func _stop_playback():
	print('fade out done')
	fader.disconnect('animation_finished', self, '_stop_playback')
	player.stop()


func play_music(name: String):
	if player.playing:
		stop_music(true)

	var asset = _get_music_name(name)
	var stream = load(asset)
	player.stream = stream

	player.play()
	fader.play_backwards('fade')
