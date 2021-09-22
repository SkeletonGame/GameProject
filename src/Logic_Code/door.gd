extends Area2D



func _on_Area2D_body_entered(body):
	#get_tree().change_scene("res://void.tscn")
	get_parent().get_parent().get_parent().get_node(".").start_transition()

