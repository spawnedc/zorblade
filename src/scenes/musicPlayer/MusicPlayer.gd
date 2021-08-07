extends Node

onready var player: AudioStreamPlayer = $Player
onready var fader: AnimationPlayer = $Player/Fader


func _get_music_name(music_name: String) -> String:
	if music_name.begins_with("res://"):
		return music_name

	return 'res://assets/music/' + music_name + '.ogg'


func stop_music(immediate: bool = false):
	if immediate == false:
		print(name, ": Fading out... ")
		fader.connect('animation_finished', self, '_stop_playback')
		fader.play('fade')
	else:
		print(name, ": Stopping immedtiately ")
		_stop_playback(null)


func _stop_playback(_anim_name):
	print(name, ": Fade out/stop complete")
	fader.disconnect('animation_finished', self, '_stop_playback')
	player.stop()


func play_music(name: String):
	print(name, ": Changing music to: ", name)
	if player.playing:
		stop_music(true)

	var asset = _get_music_name(name)
	var stream = load(asset)
	player.stream = stream

	print(name, ": Playing music: ", name, ". Fading in...")
	player.play()
	fader.play_backwards('fade')
