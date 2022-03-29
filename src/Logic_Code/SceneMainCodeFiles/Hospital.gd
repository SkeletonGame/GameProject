extends Node2D

func _ready() -> void:
	get_node("Matt/KinematicMatt").jump_lock = true
	get_parent().get_parent().get_node("Ambience").current = "hospital.wav"
