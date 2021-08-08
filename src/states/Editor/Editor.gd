extends Node2D

onready var camera: Camera2D = $camera

onready var toolbar: VBoxContainer = $UI/MarginContainer/Toolbar

onready var btn_path: Button = toolbar.get_node("AddPath")
onready var btn_new_level: Button = toolbar.get_node("NewLevel")

onready var dialog_new_level = $UI/NewLevelDialog

const camera_offset: Vector2 = Vector2(100, 0)

var selected_tool
var current_path: Path2D
var level: Level
var tmp_level: Level


func _ready():
	btn_path.connect("toggled", self, "_set_selected_tool", [Path2D])
	btn_new_level.connect("button_up", dialog_new_level, "show")
	dialog_new_level.connect("done", self, "_handle_new_level")


func _handle_new_level(new_level: Level):
	level = new_level
	print(level)


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
