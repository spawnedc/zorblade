extends Node2D

@onready var camera: Camera2D = $camera
@onready var draw_area: Node2D = $camera/DrawArea

@onready var toolbar: VBoxContainer = $UI/MarginContainer/Toolbar

@onready var btn_path: Button = toolbar.get_node("AddPath")
@onready var path_list: ItemList = toolbar.get_node("PathList")
@onready var btn_save: Button = toolbar.get_node("Save")
@onready var btn_main_menu: Button = toolbar.get_node("MainMenu")

@onready var dialog_new_level: Node2D = $UI/NewLevelDialog
@onready var dialog_new_path: Node2D = $UI/NewPathDialog
@onready var dialog_main_menu: Popup = $UI/MainMenu
@onready var dialog_file: FileDialog = $UI/FileDialog

@onready var btn_new_level: TextureButton = dialog_main_menu.get_node(
	"CenterContainer/Menu/NewLevel/Button"
)
@onready var btn_open_level: TextureButton = dialog_main_menu.get_node(
	"CenterContainer/Menu/OpenLevel/Button"
)
@onready var btn_exit: TextureButton = dialog_main_menu.get_node("CenterContainer/Menu/Exit/Button")

const camera_offset: Vector2 = Vector2(100, 0)
const base_levels_path: String = "res://data/levels/"
const level_filters = ["*.json ; JSON"]

var selected_tool
var current_path: Path2D
var level: Level
var selected_path: LevelPath
var selected_path_index: int = -1


func _ready():
	btn_exit.connect("button_up", Callable(self, "_handle_exit"))
	btn_new_level.connect("button_up", Callable(self, "_show_new_level_dialog"))
	btn_open_level.connect("button_up", Callable(self, "_show_open_level_dialog"))
	btn_path.connect("button_up", Callable(self, "_show_new_path_dialog"))
	btn_save.connect("button_up", Callable(self, "_save_level"))
	btn_main_menu.connect("button_up", Callable(self, "_show_main_menu").bind(false))

	dialog_new_level.connect("done", Callable(self, "_handle_new_level"))
	dialog_new_level.connect("cancel", Callable(self, "_handle_new_level_cancel"))

	dialog_new_path.connect("done", Callable(self, "_handle_new_path"))

	path_list.connect("item_selected", Callable(self, "_set_selected_path"))

	_show_main_menu(true)

	toolbar.visible = false


func _show_main_menu(is_exclusive: bool):
	dialog_main_menu.exclusive = is_exclusive
	dialog_main_menu.popup_centered()


func _handle_exit():
	SceneManager.goto_scene("Title")


func _show_new_level_dialog():
	dialog_main_menu.hide()
	dialog_new_level.open()


func _show_open_level_dialog():
	dialog_file.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog_file.current_dir = base_levels_path
	dialog_file.filters = level_filters
	dialog_file.connect("file_selected", Callable(self, "_handle_open_level"))
	dialog_file.popup_centered()


func _handle_open_level(path: String):
	dialog_file.disconnect("file_selected", Callable(self, "_handle_open_level"))
	dialog_main_menu.hide()
	var level_data = Utils.load_json(path)
	var new_level = Level.new()
	new_level.set_level_data(level_data)

	_handle_new_level(new_level)


func _show_new_path_dialog():
	dialog_new_path.open()


func _handle_new_level_cancel():
	dialog_main_menu.popup_centered()


func _save_level():
	dialog_file.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	dialog_file.current_dir = base_levels_path
	dialog_file.filters = level_filters
	dialog_file.connect("file_selected", Callable(self, "_handle_save_level"))
	dialog_file.popup_centered()


func _handle_save_level(path: String):
	dialog_file.disconnect("file_selected", Callable(self, "_handle_save_level"))
	var json = JSON.stringify(level.JSON.new().stringify(), "\t")
	Utils.write_file(path, json)


func _handle_new_level(new_level: Level):
	level = new_level
	path_list.clear()
	current_path = null
	for i in len(level.paths):
		path_list.add_item("Path3D " + str(i + 1))

	toolbar.visible = true

	_handle_draw_update()
	# TODO: setup initial selected thing


func _handle_new_path(path: LevelPath):
	level.paths.append(path)
	path_list.add_item("Path3D " + str(len(level.paths)))
	# TODO: setup initial selected thing


func _set_selected_tool(button_pressed: bool, new_tool):
	if button_pressed:
		selected_tool = new_tool
	else:
		selected_tool = null


func _set_selected_path(index):
	selected_tool = Path2D
	selected_path_index = index
	current_path = Path2D.new()

	var path: LevelPath = level.paths[selected_path_index]
	if len(path.points) > 1:
		current_path.curve = Utils.array_to_curve(path.points, path.curve_smoothness)
	else:
		current_path.curve = Curve2D.new()
		for point in level.paths[selected_path_index].points:
			current_path.curve.add_point(point)

	_handle_draw_update()


func _unhandled_input(event: InputEvent):
	if selected_tool:
		if event.is_action_pressed("editor_click"):
			var click_position: Vector2 = get_global_mouse_position()

			if selected_tool == Path2D:
				handle_path(click_position)


func handle_path(click_position: Vector2):
	var pos: Vector2 = click_position - camera_offset
	level.paths[selected_path_index].add_point(pos)

	var path: LevelPath = level.paths[selected_path_index]
	if len(path.points) > 1:
		current_path.curve = Utils.array_to_curve(path.points, path.curve_smoothness)
	else:
		current_path.curve.add_point(pos)
	_handle_draw_update()


func _handle_draw_update():
	draw_area.current_path = current_path
	draw_area.update()
