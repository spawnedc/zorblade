class_name Level

var name: String
var paths: Array = []
var total_enemies: int = 0
var enemy: LevelEnemy = LevelEnemy.new()
var music: String


func set_level_data(level_data: Dictionary):
	name = level_data["name"]

	if "music" in level_data:
		music = level_data["music"]

	enemy.set_enemy_data(level_data["enemy"])

	for path_data in level_data["paths"]:
		var path: LevelPath = LevelPath.new()
		path.set_path_data(path_data)
		paths.append(path)
		total_enemies += path.num_enemies


func get_final_position(path_index: int, enemy_index: int) -> Vector2:
	return paths[path_index].final_positions[enemy_index]


func get_max_enemies(path_index: int) -> int:
	return paths[path_index].num_enemies


func get_spawn_rate(path_index: int) -> float:
	return paths[path_index].spawn_rate


func to_json() -> Dictionary:
	var paths_array = []

	for path in paths:
		paths_array.append(path.to_json())

	var level_data: Dictionary = {
		"name": name, "music": music, "enemy": enemy.to_json(), "paths": paths
	}

	return level_data
