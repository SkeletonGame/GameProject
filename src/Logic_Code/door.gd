extends Area2D

func _on_Area2D_body_entered(body):
	#get_tree().change_scene("res://void.tscn")
	get_parent().get_parent().get_parent().get_node(".").start_transition("Living Room")
	## this abomination calls the function "Start Transition" in the main node of the main scene.  
	## This is using the "Living Room" argument to load the living room scene.
