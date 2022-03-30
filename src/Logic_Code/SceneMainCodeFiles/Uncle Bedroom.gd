extends Node2D

func _ready() -> void:
	get_parent().get_parent().get_node("Ambient Music").current = "Hanging With Uncle.wav"
