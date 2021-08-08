extends Node2D

onready var camera: Camera2D = $camera

onready var toolbar: VBoxContainer = $UI/MarginContainer/Toolbar

onready var btn_path: Button = toolbar.get_node("AddPath")
onready var path_list: ItemList = toolbar.get_node("PathList")
onready var btn_save: Button = toolbar.get_node("Save")

onready var dialog_new_level: Node2D = $UI/NewLevelDialog
onready var dialog_new_path: Node2D = $UI/NewPathDialog
onready var dialog_main_menu: PopupDialog = $UI/MainMenu
onready var dialog_file: FileDialog = $UI/FileDialog

onready var btn_new_level: TextureButton = dialog_main_menu.get_node(
	"CenterContainer/Menu/NewLevel/Button"
)
onready var btn_exit: TextureButton = dialog_main_menu.get_node("CenterContainer/Menu/Exit/Button")

const camera_offset: Vector2 = Vector2(100, 0)
const base_levels_path: String = "res://data/levels/"
const level_filters: PoolStringArray = PoolStringArray(["*.json ; JSON"])

var selected_tool
var current_path: Path2D
var level: Level
var selected_path: LevelPath
var selected_path_index: int = -1


func _ready():
	btn_exit.connect("button_up", self, "_handle_exit")
	btn_new_level.connect("button_up", self, "_show_new_level_dialog")
	btn_path.connect("button_up", self, "_show_new_path_dialog")
	btn_save.connect("button_up", self, "_save_level")

	dialog_new_level.connect("done", self, "_handle_new_level")
	dialog_new_level.connect("cancel", self, "_handle_new_level_cancel")

	dialog_new_path.connect("done", self, "_handle_new_path")

	path_list.connect("item_selected", self, "_set_selected_path")

	dialog_main_menu.popup_centered()

	toolbar.visible = false


func _handle_exit():
	SceneManager.goto_scene("Title")


func _show_new_level_dialog():
	dialog_main_menu.hide()
	dialog_new_level.show()


func _show_new_path_dialog():
	dialog_new_path.show()


func _handle_new_level_cancel():
	dialog_main_menu.popup_centered()


func _save_level():
	dialog_file.mode = FileDialog.MODE_SAVE_FILE
	dialog_file.current_dir = base_levels_path
	dialog_file.filters = level_filters
	dialog_file.connect("file_selected", self, "_handle_save_level")
	dialog_file.popup_centered()


func _handle_save_level(path: String):
	dialog_file.disconnect("file_selected", self, "_handle_save_level")
	var json = JSON.print(level.to_json(), "\t")
	Utils.write_file(path, json)


func _handle_new_level(new_level: Level):
	level = new_level
	toolbar.visible = true
	# TODO: setup initial selected thing


func _handle_new_path(path: LevelPath):
	level.paths.append(path)
	path_list.add_item("Path " + str(len(level.paths)))
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
	current_path.curve = Curve2D.new()

	for point in level.paths[selected_path_index].points:
		current_path.curve.add_point(point)

	update()


func _unhandled_input(event: InputEvent):
	if selected_tool:
		if event.is_action_pressed("editor_click"):
			var click_position: Vector2 = get_global_mouse_position()

			if selected_tool == Path2D:
				handle_path(click_position)


func handle_path(click_position: Vector2):
	level.paths[selected_path_index].add_point(click_position)

	var path: LevelPath = level.paths[selected_path_index]
	if len(path.points) > 1:
		current_path.curve = Utils.array_to_curve(path.points, path.curve_smoothness)
	else:
		current_path.curve.add_point(click_position)
	update()


func _draw():
	if current_path:
		draw_polyline(current_path.curve.get_baked_points(), Color.aquamarine, 1)

		for i in current_path.curve.get_point_count():
			var pos = current_path.curve.get_point_position(i)
			draw_circle(pos, 5, Color.aquamarine)
