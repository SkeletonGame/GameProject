extends Node2D

var duck = load("res://src/scenes/classes/duck.tscn")
var RNG = RandomNumberGenerator.new()
var pick = 0
func _ready() -> void:
	addaduck()

var number_of_ducks = 0
func addaduck():
	number_of_ducks += 1
	add_child(duck.instance())
	get_node("duck").name = "duck" + String(number_of_ducks)

var targets = []
var target_y = 0
func targeting():
	if targets.size() > 0:
		target_y = get_node(targets[0]).get_node("duck").position.y + get_parent().position.y
		print(target_y)

func _process(delta: float) -> void:
	targeting()
