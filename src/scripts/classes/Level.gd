extends Object

const LevelPath = preload("res://scripts/classes/LevelPath.gd")
const LevelEnemy = preload("res://scripts/classes/LevelEnemy.gd")
var name: String
var paths: Array = []
var total_enemies: int = 0
var enemy: LevelEnemy
var music: String


func _init(level_data):
	name = level_data["name"]
	music = level_data["music"]
	enemy = LevelEnemy.new(level_data["enemy"])

	for path_data in level_data["paths"]:
		var path: LevelPath = LevelPath.new(path_data)
		paths.append(path)
		total_enemies += path.num_enemies


func get_final_position(path_index: int, enemy_index: int) -> Vector2:
	return paths[path_index].final_positions[enemy_index]


func get_max_enemies(path_index: int) -> int:
	return paths[path_index].num_enemies


func get_spawn_rate(path_index: int) -> float:
	return paths[path_index].spawn_rate
