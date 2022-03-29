extends Node2D

var x_change = 0
var y_change = 0
var x_m = 1.3
var y_m = 1.1

var camera_current_pos = Vector2(0, 0)
var camera_starting_pos = Vector2(0, 0)

func _ready() -> void:
	camera_starting_pos = get_parent().get_node("Matt/KinematicMatt/Camera2D").get_camera_screen_center()

func _process(delta: float) -> void:
	camera_current_pos = get_parent().get_node("Matt/KinematicMatt/Camera2D").get_camera_screen_center()
	x_change = (camera_current_pos[0] - camera_starting_pos[0]) * x_m / -10
	y_change = (camera_current_pos[1] - camera_starting_pos[1]) * y_m / -10
	set_position(Vector2(x_change, y_change))
