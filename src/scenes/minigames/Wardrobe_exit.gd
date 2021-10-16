extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		get_parent().get_parent().get_node(".").start_transition("Bedroom")
