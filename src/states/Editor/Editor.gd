extends Node2D

onready var camera: Camera2D = $camera

onready var toolbar: VBoxContainer = $UI/MarginContainer/Toolbar

onready var btn_path: Button = toolbar.get_node("AddPath")
onready var btn_new_level: Button = toolbar.get_node("NewLevel")

onready var dialog_new_level: PopupDialog = $UI/NewLevelDialog
onready var dialog_file_select: FileDialog = $UI/FileDialog

onready var grid: GridContainer = dialog_new_level.get_node("VBoxContainer/GridContainer")
onready var buttons: GridContainer = dialog_new_level.get_node("VBoxContainer/ButtonsContainer")

onready var btn_select_music: ToolButton = grid.get_node("MusicSelector/Button")
onready var btn_select_enemy: ToolButton = grid.get_node("EnemySelector/Button")

onready var btn_save: Button = buttons.get_node("Save")
onready var btn_cancel: Button = buttons.get_node("Cancel")

onready var label_music: Label = grid.get_node("MusicSelector/Label")
onready var label_enemy: Label = grid.get_node("EnemySelector/Label")

onready var input_level_name: LineEdit = grid.get_node("Levelinput")
onready var input_enemy_speed: LineEdit = grid.get_node("EnemySpeedInput")
onready var input_enemy_health: LineEdit = grid.get_node("EnemyHealthInput")
onready var input_enemy_points: LineEdit = grid.get_node("EnemyPointsInput")

const camera_offset: Vector2 = Vector2(100, 0)

const base_music_path: String = "res://assets/music/"
const music_filters: PoolStringArray = PoolStringArray(["*.ogg ; OGG", "*.mp3 ; MP3"])

const base_enemies_path: String = "res://assets/"
const enemy_filters: PoolStringArray = PoolStringArray(["*.png ; PNG"])

var selected_tool
var current_path: Path2D
var level: Level


func _ready():
	btn_path.connect("toggled", self, "_set_selected_tool", [Path2D])
	btn_new_level.connect("button_up", self, "_show_new_level_dialog")
	btn_select_music.connect("button_up", self, "_show_select_music_dialog")
	btn_select_enemy.connect("button_up", self, "_show_select_enemy_dialog")

	btn_cancel.connect("button_up", dialog_new_level, "hide")
	btn_save.connect("button_up", self, "_handle_save")

	input_level_name.connect("text_changed", self, "_handle_level_name_change")
	input_enemy_speed.connect("text_changed", self, "_handle_enemy_speed_change")
	input_enemy_health.connect("text_changed", self, "_handle_enemy_health_change")
	input_enemy_points.connect("text_changed", self, "_handle_enemy_points_change")


func _show_new_level_dialog():
	level = Level.new()
	dialog_new_level.popup_centered()


func _show_select_music_dialog():
	dialog_file_select.current_dir = base_music_path
	dialog_file_select.filters = music_filters
	dialog_file_select.connect("file_selected", self, "_handle_music_select")
	dialog_file_select.popup_centered()


func _show_select_enemy_dialog():
	dialog_file_select.current_dir = base_enemies_path
	dialog_file_select.filters = enemy_filters
	dialog_file_select.connect("file_selected", self, "_handle_enemy_select")
	dialog_file_select.popup_centered()


func _handle_music_select(path: String):
	dialog_file_select.disconnect("file_selected", self, "_handle_music_select")
	var name = path.replace(base_music_path, "")
	label_music.text = name
	level.music = name


func _handle_enemy_select(path: String):
	dialog_file_select.disconnect("file_selected", self, "_handle_enemy_select")
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


func _handle_save():
	var json = level.to_json()

	print(JSON.print(json, "\t"))


func _set_selected_tool(button_pressed: bool, new_tool):
	if button_pressed:
		selected_tool = new_tool
	else:
		selected_tool = null


func _unhandled_input(event: InputEvent):
	if selected_tool:
		if event.is_action_pressed("editor_click"):
			var click_position: Vector2 = get_global_mouse_position()

			if selected_tool == Path2D:
				handle_path(click_position)


func handle_path(click_position: Vector2):
	if not current_path:
		current_path = Path2D.new()
		current_path.curve = Curve2D.new()

	current_path.curve.add_point(click_position)
	update()


func _draw():
	if current_path:
		draw_polyline(current_path.curve.get_baked_points(), Color.aquamarine, 1)
		var points: PoolVector2Array = []

		for i in current_path.curve.get_point_count():
			var pos = current_path.curve.get_point_position(i)
			points.append(pos)
			draw_circle(pos, 5, Color.aquamarine)

		print(points)
