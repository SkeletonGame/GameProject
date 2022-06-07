extends Node2D

var boat = load("res://src/scenes/minigames/Classes/Boat.tscn")
var dangerwave = load("res://src/scenes/minigames/Classes/Dangerwave.tscn")
var starting_positions = [
	[Vector2(1000, 1000), 225],
	[Vector2(1000, -1000), 135],
	[Vector2(-1000, 1000), -45],
	[Vector2(-1000, -1000), 45]
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
	get_node("Red").position = starting_positions[0][0]
	get_node("Red").rotation_degrees = starting_positions[0][1]

var current_camera = "Red"
var spectate_num = 0
var boatlist = ["Red", "Yellow", "Blue", "Green"]
var boatlist_changed = true
func camera_manager():
	if boatlist_changed:
		if spectate_num >= boatlist.size():
			spectate_num = 0
		current_camera = boatlist[spectate_num]
		get_node(current_camera).get_node("Camera2D").current = true
		boatlist_changed = false
	if not "Red" in boatlist and Input.is_action_just_pressed("space"):
		if spectate_num < boatlist.size() - 1:
			spectate_num += 1
		else:
			spectate_num = 0
		current_camera = boatlist[spectate_num]
		get_node(current_camera).get_node("Camera2D").current = true

var position_angle = 0
var position_length = 0
func random_wave():
	add_child(dangerwave.instance())
	RNG.randomize()
	get_node("Dangerwave").velocity_power = RNG.randi_range(2000, 10000)
	RNG.randomize()
	get_node("Dangerwave").rotation_degrees = RNG.randf_range(0, 360)
	RNG.randomize()
	position_angle = RNG.randf_range(0, 2 * PI)
	RNG.randomize()
	position_length = RNG.randf_range(0, 3000)
	#get_node("Dangerwave").position = Vector2(
	#	cos(position_angle) * position_length,
	#	sin(position_angle) * position_length)
	get_node("Dangerwave").name = "DangerwaveInMotion"

var wave_timer = 0
var wave_frequency = 0.01
func _process(delta: float) -> void:
	camera_manager()
	wave_timer += delta
	if wave_timer > 1 - wave_frequency:
		random_wave()
		wave_frequency += 0.002
		wave_timer = 0
