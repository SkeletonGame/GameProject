extends Node2D

var duck = load("res://src/scenes/classes/duck.tscn")
var RNG = RandomNumberGenerator.new()
var pick = 0

var number_of_ducks = 0
func addaduck():
	number_of_ducks += 1
	add_child(duck.instance())
	get_node("duck").name = "duck" + String(number_of_ducks)

var targets = []
var target_y = 0
var target_angle = 0
var acc = 0
var smoke_pos = Vector2(0, 0)
func targeting():
	if targets.size() > 0:
		target_y = get_node(targets[0]).get_node("duck").local_y
		target_angle = target_y / 5.7 # local_y is tailored to make this math way easier
	else:
		target_angle = 0
	if target_angle > get_node("cowboyarm").rotation_degrees + 2:
		acc += 0.16
	elif target_angle < get_node("cowboyarm").rotation_degrees - 2:
		acc -= 0.16
	elif targets.size() > 0:
		get_node(targets[0]).get_node("duck").mode = "dead"
		targets.remove(0)
		number_of_ducks -= 1
		acc += 2.5
	acc *= 0.85
	get_node("cowboyarm").rotation_degrees += acc
	smoke_pos = get_node("cowboyarm").position # set it to where the arm is
	smoke_pos += Vector2(-149, -51) # adjust to end of arm
	smoke_pos[0] += get_node("cowboyarm").rotation_degrees / 1.5
	smoke_pos[1] += get_node("cowboyarm").rotation_degrees * -2.8
	get_node("smoke").position = smoke_pos

var timer = 0
var music = true
func _process(delta: float) -> void:
	if music and not get_node("yeehaw").playing:
		get_node("yeehaw").playing = true
	targeting()
	timer += delta
	if number_of_ducks < 3 and timer > RNG.randf_range(0.4, 3):
		addaduck()
		timer = 0
		RNG.randomize()
	
