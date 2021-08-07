extends Node2D

onready var camera: Camera2D = $camera

const camera_offset: Vector2 = Vector2(100, 0)


func _input(event):
	if event.is_action_pressed("editor_click"):
		print(get_global_mouse_position() - camera_offset)

# func _process(_delta):
# 	drag_mode = Input.is_mouse_button_pressed(BUTTON_LEFT)

# 	if drag_mode:
# 		camera.look_at(get_global_mouse_position())
# 		# camera.position = get_global_mouse_position()
# 		# print(get_global_mouse_position())
