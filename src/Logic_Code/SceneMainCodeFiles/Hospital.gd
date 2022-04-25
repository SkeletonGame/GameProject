extends Node2D

signal jumplock

func _ready() -> void:
	get_tree().call_group("kinematt", "jumplck")
	## get_node("Matt/KinematicMatt").jump_lock = true


