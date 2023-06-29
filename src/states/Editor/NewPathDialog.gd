extends Node2D

signal done(path)
signal cancel

@onready var dialog_new_path: Popup = $PathDialog

@onready var grid: GridContainer = dialog_new_path.get_node("VBoxContainer/GridContainer")
@onready var buttons: GridContainer = dialog_new_path.get_node("VBoxContainer/ButtonsContainer")

@onready var btn_done: Button = buttons.get_node("Done")
@onready var btn_cancel: Button = buttons.get_node("Cancel")

@onready var input_num_enemies: LineEdit = grid.get_node("NumEnemiesInput")
@onready var input_spawn_rate: LineEdit = grid.get_node("SpawnRateInput")
@onready var input_spawn_delay: LineEdit = grid.get_node("SpawnDelayInput")
@onready var input_curve_smoothness: LineEdit = grid.get_node("CurveSmoothnessInput")
@onready var input_loop: CheckBox = grid.get_node("LoopInput")
@onready var input_rotate: CheckBox = grid.get_node("RotateInput")

var path: LevelPath


func _ready():
	btn_cancel.connect("button_up", Callable(self, "_handle_cancel"))
	btn_done.connect("button_up", Callable(self, "_handle_done"))


func open():
	path = LevelPath.new()
	input_loop.button_pressed = path.loop
	input_rotate.button_pressed = path.rotate
	input_curve_smoothness.text = str(path.curve_smoothness)
	dialog_new_path.popup_centered()


func _handle_done():
	path.num_enemies = int(input_num_enemies.text)
	path.spawn_rate = float(input_spawn_rate.text)
	path.spawn_delay = float(input_spawn_delay.text)
	path.curve_smoothness = int(input_curve_smoothness.text)
	path.loop = input_loop.button_pressed
	path.rotate = input_rotate.button_pressed

	emit_signal("done", path)
	dialog_new_path.hide()


func _handle_cancel():
	emit_signal("cancel")
	dialog_new_path.hide()
