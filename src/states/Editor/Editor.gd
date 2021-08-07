extends Node2D

onready var camera: Camera2D = $camera
onready var draw_area: Node2D = $camera/DrawArea
onready var btn_path: Button = $UI/btn_path

const camera_offset: Vector2 = Vector2(100, 0)

var selected_tool
var current_path: Path2D


func _ready():
	btn_path.connect("toggled", self, "_set_selected_tool", [Path2D])


func _set_selected_tool(button_pressed: bool, new_tool):
	if button_pressed:
		selected_tool = new_tool
	else:
		selected_tool = null


func _input(event):
	if selected_tool:
		if event.is_action_pressed("editor_click"):
			var click_position: Vector2 = get_global_mouse_position()

			if selected_tool == Path2D:
				handle_path(click_position)


func handle_path(click_position: Vector2):
	print(current_path)
	if not current_path:
		current_path = Path2D.new()
		current_path.curve = Curve2D.new()

	current_path.curve.add_point(click_position)
	update()


func _draw():
	if current_path:
		draw_polyline(current_path.curve.get_baked_points(), Color.aquamarine, 1)
