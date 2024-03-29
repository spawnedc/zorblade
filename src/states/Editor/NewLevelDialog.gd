extends Node2D

signal done(level)
signal cancel

@onready var dialog_new_level: Popup = $LevelDialog
@onready var dialog_file: FileDialog = $FileDialog

@onready var grid: GridContainer = dialog_new_level.get_node("VBoxContainer/GridContainer")
@onready var buttons: GridContainer = dialog_new_level.get_node("VBoxContainer/ButtonsContainer")

@onready var btn_select_music: Button = grid.get_node("MusicSelector/Button")
@onready var btn_select_enemy: Button = grid.get_node("EnemySelector/Button")

@onready var btn_done: Button = buttons.get_node("Done")
@onready var btn_cancel: Button = buttons.get_node("Cancel")

@onready var label_music: Label = grid.get_node("MusicSelector/Label")
@onready var label_enemy: Label = grid.get_node("EnemySelector/Label")

@onready var input_level_name: LineEdit = grid.get_node("Levelinput")
@onready var input_enemy_speed: LineEdit = grid.get_node("EnemySpeedInput")
@onready var input_enemy_health: LineEdit = grid.get_node("EnemyHealthInput")
@onready var input_enemy_points: LineEdit = grid.get_node("EnemyPointsInput")

const base_music_path: String = "res://assets/music/"
const music_filters = ["*.ogg ; OGG", "*.mp3 ; MP3"]

const base_enemies_path: String = "res://assets/"
const enemy_filters = ["*.png ; PNG"]

var level: Level


func _ready():
	btn_select_music.connect("button_up", Callable(self, "_show_select_music_dialog"))
	btn_select_enemy.connect("button_up", Callable(self, "_show_select_enemy_dialog"))

	btn_cancel.connect("button_up", Callable(self, "_handle_cancel"))
	btn_done.connect("button_up", Callable(self, "_handle_done"))


func open():
	level = Level.new()
	dialog_new_level.popup_centered()


func _handle_done():
	level.name = input_level_name.text
	level.enemy.speed = float(input_enemy_speed.text)
	level.enemy.health = float(input_enemy_health.text)
	level.enemy.points = int(input_enemy_points.text)
	emit_signal("done", level)
	dialog_new_level.hide()


func _handle_cancel():
	emit_signal("cancel")
	dialog_new_level.hide()


func _show_select_music_dialog():
	dialog_file.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog_file.current_dir = base_music_path
	dialog_file.filters = music_filters
	dialog_file.connect("file_selected", Callable(self, "_handle_music_select"))
	dialog_file.popup_centered()


func _show_select_enemy_dialog():
	dialog_file.file_mdoe = FileDialog.FILE_MODE_OPEN_FILE
	dialog_file.current_dir = base_enemies_path
	dialog_file.filters = enemy_filters
	dialog_file.connect("file_selected", Callable(self, "_handle_enemy_select"))
	dialog_file.popup_centered()


func _handle_music_select(path: String):
	dialog_file.disconnect("file_selected", Callable(self, "_handle_music_select"))
	var name = path.replace(base_music_path, "")
	label_music.text = name
	level.music = name


func _handle_enemy_select(path: String):
	dialog_file.disconnect("file_selected", Callable(self, "_handle_enemy_select"))
	var name = path.replace(base_enemies_path, "")
	label_enemy.text = name
	level.enemy.sprite = name
