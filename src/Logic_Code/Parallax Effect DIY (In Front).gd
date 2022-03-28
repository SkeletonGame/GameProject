extends Node2D

var x_change = 0
var y_change = 0
var x_offset = 0
var y_offset = 70
var x_m = 1.2
var y_m = 1.04

var camera_current_pos = Vector2(0, 0)
var camera_starting_pos = Vector2(0, 0)

func _ready() -> void:
	camera_starting_pos = get_parent().get_node("Matt/KinematicMatt/Camera2D").position

func _process(delta: float) -> void:
	camera_current_pos = get_parent().get_node("Matt/KinematicMatt/Camera2D").get_global_position()
	x_change = (camera_current_pos[0] - camera_starting_pos[0]) * x_m / -10
	y_change = (camera_current_pos[1] - camera_starting_pos[1]) * y_m / -10
	set_position(Vector2(x_change + x_offset, y_change + y_offset))
