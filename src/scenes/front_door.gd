extends CollisionShape2D

func _on_FrontDoor_body_entered(body: Node) -> void:
	get_parent().get_parent().get_parent().get_parent().start_transition("Outside Apartment")
	
	#.get_node(".").start_transition("Outside Apartment")
