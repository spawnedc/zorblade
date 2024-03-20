extends Node2D

var loot_table: Array[Powerup] = []
var probabilities = []
var random_range: int = 2000
const powerups_data_dir = "res://data/powerups"

@onready var spawner = $spawner


func _ready():
	randomize()
	for file in DirAccess.get_files_at(powerups_data_dir):
		var resource_file = powerups_data_dir + "/" + file
		var powerup: Powerup = load(resource_file) as Powerup
		loot_table.append(powerup)
		
	print(loot_table)

	#loot_table = Utils.load_json("loot_table")
	_generate_loot_table()
	GameManager.connect("enemy_death", Callable(self, "_on_enemy_death"))


func _generate_loot_table():
	for powerup in loot_table:
		random_range += powerup.drop_rate

	print(random_range)

	for powerup in loot_table:
		probabilities.append(powerup.drop_rate / random_range)
		
	print(probabilities)


func _get_drop():
	var roll: float = randf()
	var choice: int = -1

	for i in range(0, loot_table.size()):
		if roll > probabilities[i]:
			roll -= probabilities[i]
		elif choice == -1:
			choice = i

	return choice


func _on_enemy_death(enemy):
	var drop_index = _get_drop()

	# 0 is nothing.
	if drop_index > 0:
		var loot: Powerup = loot_table[drop_index]
		var powerup_scene = loot.scene
		if not powerup_scene:
			powerup_scene = load("res://scenes/powerups/GenericPowerup.tscn")

		var powerup = spawner.spawn(powerup_scene)
		powerup.global_position = enemy.global_position
		powerup.set_powerup_data(loot)
		powerup.connect(
			"area_entered",
			Callable(CollisionManager, "handle_player_picked_up_powerup").bind(powerup, loot)
		)
