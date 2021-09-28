extends CollisionShape2D

var overlap = 0
func _on_BedroomDoor_body_entered(body: Node) -> void:
	overlap = 1

func _on_BedroomDoor_body_exited(body: Node) -> void:
	overlap = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and overlap:
		get_parent().get_parent().get_parent().get_parent().get_node(".").start_transition("Bedroom")
