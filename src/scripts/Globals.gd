extends Node

const GROUP_PLAYER = 'player'
const GROUP_PLAYER_BULLET = 'player_bullet'
const GROUP_ENEMY = 'enemy'
const GROUP_ENEMY_BULLET = 'enemy_bullet'

var VIEWPORT_WIDTH: int = ProjectSettings.get_setting("display/window/size/width")
var VIEWPORT_HEIGHT: int = ProjectSettings.get_setting("display/window/size/height")
var VIEWPORT_SIZE: Vector2 = Vector2(VIEWPORT_WIDTH, VIEWPORT_HEIGHT)
