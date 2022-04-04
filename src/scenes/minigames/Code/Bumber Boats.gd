extends Node2D

var boat = load("res://src/scenes/minigames/Classes/Boat.tscn")
var starting_positions = [
	[Vector2(1000, 1000), 225],
	[Vector2(1000, -1000), 135],
	[Vector2(-1000, 1000), -45]
]
var RNG = RandomNumberGenerator.new()
var pick = 0
func _ready() -> void:
	for this in ["Yellow", "Blue", "Green"]:
		add_child(boat.instance())
		RNG.randomize()
		pick = RNG.randi_range(0, starting_positions.size() - 1)
		get_node("Boat").position = starting_positions[pick][0]
		get_node("Boat").rotation_degrees = starting_positions[pick][1]
		get_node("Boat").color = this
		starting_positions.remove(pick)
		get_node("Boat").name = this
	get_node("Red").color = "Red"
