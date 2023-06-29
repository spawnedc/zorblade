extends Node

const GROUP_PLAYER = 'player'
const GROUP_PLAYER_BULLET = 'player_bullet'
const GROUP_ENEMY = 'enemy'
const GROUP_ENEMY_BULLET = 'enemy_bullet'

var VIEWPORT_WIDTH: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var VIEWPORT_HEIGHT: int = ProjectSettings.get_setting("display/window/size/viewport_height")
var VIEWPORT_SIZE: Vector2 = Vector2(VIEWPORT_WIDTH, VIEWPORT_HEIGHT)

const LEVEL_START_DELAY: int = 2

var IS_DEBUG: bool = OS.is_debug_build()

const LEVEL_LIST = ['level1', 'level2', 'level3', 'level4']
