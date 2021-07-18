extends Node

const GROUP_PLAYER = 'player'
const GROUP_PLAYER_BULLET = 'player_bullet'
const GROUP_ENEMY = 'enemy'
const GROUP_ENEMY_BULLET = 'enemy_bullet'

var VIEWPORT_SIZE: Vector2 = Vector2.ZERO


func _ready():
	VIEWPORT_SIZE = get_viewport().size
