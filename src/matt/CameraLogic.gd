extends Node2D

func _process(delta: float) -> void:
	get_parent().get_node("KinematicMatt").get_node("Camera2D").limit_left = -2600
	get_parent().get_node("KinematicMatt").get_node("Camera2D").limit_right = 1510
	get_parent().get_node("KinematicMatt").get_node("Camera2D").limit_top = -1900
