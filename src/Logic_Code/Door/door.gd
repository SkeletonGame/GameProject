extends Area2D

signal transition(room)

func _on_Area2D_body_entered(body):
	var MainNode = get_parent().get_parent().get_parent()
	MainNode.start_transition("Living Room")
