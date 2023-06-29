extends Node2D

@onready var dynamic_paths: Node2D = $dynamicPaths

const Level = preload('res://scripts/classes/Level.gd')
const LevelPath = preload('res://scripts/classes/LevelPath.gd')
const enemy_scene = preload('res://scenes/enemies/Enemy.tscn')
const ship_path_follow = preload('res://scenes/enemies/ShipPathFollow.tscn')

var timer_call_counts: Array = []
var timers: Array = []


func _ready():
	GameManager.connect("level_change", Callable(self, "_on_level_change"))
	GameManager.connect("level_start", Callable(self, "_on_level_start"))


func _on_level_start():
	for timer in timers:
		timer.start()


func _on_level_change(level: Level):
	timer_call_counts.clear()
	timers.clear()

	for child in dynamic_paths.get_children():
		child.queue_free()

	_create_paths(level)


func _create_paths(level: Level):
	for index in len(level.paths):
		timer_call_counts.append(0)
		var path: LevelPath = level.paths[index]
		var path_2d: Path2D = Path2D.new()

		var curve: Curve2D = Utils.array_to_curve(path.points, path.curve_smoothness)

		path_2d.curve = curve

		dynamic_paths.add_child(path_2d)

		var timer: Timer = Timer.new()
		timer.autostart = false
		timer.one_shot = true
		timer.wait_time = path.spawn_rate + path.spawn_delay
		timer.connect("timeout", Callable(self, "_on_path_timer_timeout").bind(timer, path_2d, index))

		dynamic_paths.add_child(timer)

		timers.append(timer)


func _on_path_timer_timeout(timer, path_2d, path_index) -> void:
	var level: Level = GameManager.current_level
	var path_follow = ship_path_follow.instantiate()
	var enemy = enemy_scene.instantiate()
	enemy.set_texture(level.enemy.sprite, level.enemy.scale)

	path_follow.add_child(enemy)

	path_follow.set_velocity(level.enemy.speed)
	path_follow.loop = level.paths[path_index].loop
	path_follow.rotates = level.paths[path_index].rotate

	path_2d.add_child(path_follow)

	enemy.add_to_group(Globals.GROUP_ENEMY)
	enemy.set_velocity(level.enemy.speed)
	enemy.set_health(level.enemy.health)
	enemy.set_points(level.enemy.points)
	enemy.global_rotation_degrees = 0
	enemy.connect("dead", Callable(self, "_on_enemy_dead").bind(enemy, path_follow))
	enemy.connect("ready_to_be_removed", Callable(self, "_on_enemy_ready_to_be_removed").bind(enemy))

	if path_follow.loop == false:
		var enemy_index = timer_call_counts[path_index]
		var final_position = level.get_final_position(path_index, enemy_index)
		enemy.set_final_position(final_position + global_position)
		path_follow.connect("reached_end", Callable(self, "_on_enemy_reached_path_end").bind(enemy))

	timer_call_counts[path_index] += 1

	var enemy_count = timer_call_counts[path_index]

	if enemy_count < level.get_max_enemies(path_index):
		timer.wait_time = level.paths[path_index].spawn_rate
		timer.start()


func _on_enemy_reached_path_end(enemy) -> void:
	enemy.move_to_final_position()


func _on_enemy_dead(enemy, path_follow):
	GameManager.enemy_dead(enemy)
	path_follow.set_velocity(0)


func _on_enemy_ready_to_be_removed(enemy):
	GameManager.remove_enemy(enemy)
	enemy.queue_free()
