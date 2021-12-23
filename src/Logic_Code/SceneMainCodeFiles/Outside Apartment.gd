extends Node2D

func _ready() -> void:
	get_parent().get_parent().get_node("Ambience").current = "quiet streets.wav"
