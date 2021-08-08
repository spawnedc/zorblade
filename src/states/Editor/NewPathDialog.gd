extends Node2D

signal done(path)
signal cancel

onready var dialog_new_path: PopupDialog = $PathDialog

onready var grid: GridContainer = dialog_new_path.get_node("VBoxContainer/GridContainer")
onready var buttons: GridContainer = dialog_new_path.get_node("VBoxContainer/ButtonsContainer")

onready var btn_done: Button = buttons.get_node("Done")
onready var btn_cancel: Button = buttons.get_node("Cancel")

onready var input_num_enemies: LineEdit = grid.get_node("NumEnemiesInput")
onready var input_spawn_rate: LineEdit = grid.get_node("SpawnRateInput")
onready var input_spawn_delay: LineEdit = grid.get_node("SpawnDelayInput")
onready var input_curve_smoothness: LineEdit = grid.get_node("CurveSmoothnessInput")
onready var input_loop: CheckBox = grid.get_node("LoopInput")
onready var input_rotate: CheckBox = grid.get_node("RotateInput")

var path: LevelPath


func _ready():
	btn_cancel.connect("button_up", self, "_handle_cancel")
	btn_done.connect("button_up", self, "_handle_done")

	input_num_enemies.connect("text_changed", self, "_handle_num_enemies_change")
	input_spawn_rate.connect("text_changed", self, "_handle_spawn_rate_change")
	input_spawn_delay.connect("text_changed", self, "_handle_spawn_delay_change")
	input_curve_smoothness.connect("text_changed", self, "_handle_curve_smoothness_change")

	input_loop.connect("toggled", self, "_handle_loop_toggle")
	input_rotate.connect("toggled", self, "_handle_rotate_toggle")


func show():
	path = LevelPath.new()
	input_loop.pressed = path.loop
	input_rotate.pressed = path.rotate
	input_curve_smoothness.text = str(path.curve_smoothness)
	dialog_new_path.popup_centered()


func _handle_done():
	emit_signal("done", path)
	dialog_new_path.hide()


func _handle_cancel():
	emit_signal("cancel")
	dialog_new_path.hide()


func _handle_num_enemies_change(text: String):
	path.num_enemies = int(text)


func _handle_spawn_rate_change(text: String):
	path.spawn_rate = float(text)


func _handle_spawn_delay_change(text: String):
	path.spawn_delay = float(text)


func _handle_curve_smoothness_change(text: String):
	path.curve_smoothness = int(text)


func _handle_loop_toggle(is_toggled: bool):
	path.loop = is_toggled


func _handle_rotate_toggle(is_toggled: bool):
	path.rotate = is_toggled
