extends Node2D

func _ready() -> void:
	get_parent().get_parent().get_node("Ambience").current = "morning sounds.wav"
	get_parent().get_parent().get_node("Ambient Music").current = ""
	get_node("Matt").get_node("CameraLogic").new = "x0.5"
