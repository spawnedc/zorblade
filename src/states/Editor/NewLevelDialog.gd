extends Node2D

signal done(level)

onready var dialog_new_level: PopupDialog = $LevelDialog
onready var dialog_file: FileDialog = $FileDialog

onready var grid: GridContainer = dialog_new_level.get_node("VBoxContainer/GridContainer")
onready var buttons: GridContainer = dialog_new_level.get_node("VBoxContainer/ButtonsContainer")

onready var btn_select_music: ToolButton = grid.get_node("MusicSelector/Button")
onready var btn_select_enemy: ToolButton = grid.get_node("EnemySelector/Button")

onready var btn_done: Button = buttons.get_node("Done")
onready var btn_cancel: Button = buttons.get_node("Cancel")

onready var label_music: Label = grid.get_node("MusicSelector/Label")
onready var label_enemy: Label = grid.get_node("EnemySelector/Label")

onready var input_level_name: LineEdit = grid.get_node("Levelinput")
onready var input_enemy_speed: LineEdit = grid.get_node("EnemySpeedInput")
onready var input_enemy_health: LineEdit = grid.get_node("EnemyHealthInput")
onready var input_enemy_points: LineEdit = grid.get_node("EnemyPointsInput")

const base_music_path: String = "res://assets/music/"
const music_filters: PoolStringArray = PoolStringArray(["*.ogg ; OGG", "*.mp3 ; MP3"])

const base_enemies_path: String = "res://assets/"
const enemy_filters: PoolStringArray = PoolStringArray(["*.png ; PNG"])

const base_levels_path: String = "res://data/levels/"
const level_filters: PoolStringArray = PoolStringArray(["*.json ; JSON"])

var level: Level


func _ready():
	btn_select_music.connect("button_up", self, "_show_select_music_dialog")
	btn_select_enemy.connect("button_up", self, "_show_select_enemy_dialog")

	btn_cancel.connect("button_up", dialog_new_level, "hide")
	btn_done.connect("button_up", self, "_handle_done")

	input_level_name.connect("text_changed", self, "_handle_level_name_change")
	input_enemy_speed.connect("text_changed", self, "_handle_enemy_speed_change")
	input_enemy_health.connect("text_changed", self, "_handle_enemy_health_change")
	input_enemy_points.connect("text_changed", self, "_handle_enemy_points_change")


func show():
	level = Level.new()
	dialog_new_level.popup_centered()


func _handle_done():
	emit_signal("done", level)
	dialog_new_level.hide()


func _show_select_music_dialog():
	dialog_file.mode = FileDialog.MODE_OPEN_FILE
	dialog_file.current_dir = base_music_path
	dialog_file.filters = music_filters
	dialog_file.connect("file_selected", self, "_handle_music_select")
	dialog_file.popup_centered()


func _show_select_enemy_dialog():
	dialog_file.mode = FileDialog.MODE_OPEN_FILE
	dialog_file.current_dir = base_enemies_path
	dialog_file.filters = enemy_filters
	dialog_file.connect("file_selected", self, "_handle_enemy_select")
	dialog_file.popup_centered()


func _handle_music_select(path: String):
	dialog_file.disconnect("file_selected", self, "_handle_music_select")
	var name = path.replace(base_music_path, "")
	label_music.text = name
	level.music = name


func _handle_enemy_select(path: String):
	dialog_file.disconnect("file_selected", self, "_handle_enemy_select")
	var name = path.replace(base_enemies_path, "")
	label_enemy.text = name
	level.enemy.sprite = name


func _handle_level_name_change(text: String):
	level.name = text


func _handle_enemy_speed_change(text: String):
	level.enemy.speed = float(text)


func _handle_enemy_health_change(text: String):
	level.enemy.health = float(text)


func _handle_enemy_points_change(text: String):
	level.enemy.points = int(text)
