extends Node2D

var loot_table = []
var probabilities = []
var random_range: int = 0
const drop_rate = 5  # percent

@onready var spawner = $spawner


func _ready():
	randomize()
	loot_table = Utils.load_json("loot_table")
	_generate_loot_table()
	GameManager.connect("enemy_death", Callable(self, "_on_enemy_death"))


func _generate_loot_table():
	for powerup in loot_table:
		random_range += powerup["drop_rate"]

	for powerup in loot_table:
		probabilities.append(powerup["drop_rate"] / random_range)


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
		var powerup_data = loot_table[drop_index]
		var powerup_scene = load("res://scenes/powerups/" + powerup_data["name"] + ".tscn")
		if not powerup_scene:
			powerup_scene = load("res://scenes/powerups/GenericPowerup.tscn")

		var powerup = spawner.spawn(powerup_scene)
		powerup.global_position = enemy.global_position
		powerup.set_powerup_data(powerup_data)
		powerup.connect(
			"area_entered",
			Callable(CollisionManager, "handle_player_picked_up_powerup").bind(powerup, powerup_data)
		)
