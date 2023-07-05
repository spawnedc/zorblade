extends CenterContainer

signal on_new_level_click
signal on_open_level_click
signal on_exit_click

@onready var btn_new_level: TextureButton = $Menu/NewLevel/Button
@onready var btn_open_level: TextureButton = $Menu/OpenLevel/Button
@onready var btn_exit: TextureButton = $Menu/Exit/Button


# Called when the node enters the scene tree for the first time.
func _ready():
	btn_new_level.connect("button_up", Callable(self, "_handle_new_level_click"))
	btn_open_level.connect("button_up", Callable(self, "_handle_open_level_click"))
	btn_exit.connect("button_up", Callable(self, "_handle_exit_click"))
	
func _handle_new_level_click():
	emit_signal("on_new_level_click")

func _handle_open_level_click():
	emit_signal("on_open_level_click")

func _handle_exit_click():
	emit_signal("on_exit_click")
