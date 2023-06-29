extends Node2D

@onready var parallax_bg = $ParallaxBackground
@onready var parallax_layer = $ParallaxBackground/ParallaxLayer
@onready var background = $ParallaxBackground/ParallaxLayer/Sprite2D


func _ready():
	var viewport_size = Globals.VIEWPORT_SIZE

	parallax_layer.set_mirroring(viewport_size)


func _process(delta):
	parallax_bg.scroll_offset.y += 100 * delta
