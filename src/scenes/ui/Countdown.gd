extends Control

signal countdown_end

onready var timer = $Timer
onready var label = $Label
export var countdown_from: int
var countdown: int
var label_prefix: String
export var show_countdown: bool = false


func _ready():
	timer.connect("timeout", self, "_on_timer_timeout")
	visible = false


func _set_label():
	if show_countdown == false:
		label.text = label_prefix
	else:
		if label_prefix != "":
			label.text = label_prefix + " "
		else:
			label.text = ""

		label.text += String(countdown)


func start(number: int, prefix: String = ""):
	countdown_from = number
	countdown = countdown_from
	label_prefix = prefix
	_set_label()

	visible = true
	timer.start()


func _on_timer_timeout():
	countdown -= 1
	if countdown == 0:
		timer.stop()
		visible = false
		emit_signal("countdown_end")
	else:
		_set_label()
