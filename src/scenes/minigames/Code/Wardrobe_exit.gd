extends Node2D

var mattLines = {"0": {"Line": "Lookin' good, Matt!", "Emotion": "joy"}}
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		get_parent().get_parent().get_node(".").start_transition("Bedroom", {"mattPos": Vector2(-2200, 0), "mattSpeak": mattLines})
