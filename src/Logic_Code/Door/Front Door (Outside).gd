extends CollisionShape2D

var overlap = 0

func _on_Front_Door_body_entered(body: Node) -> void:
	overlap = 1

func _on_Front_Door_body_exited(body: Node) -> void:
	overlap = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and overlap:
		get_parent().get_parent().get_node("Matt").get_node("CameraLogic").new = "x1"
		get_parent().get_parent().get_parent().get_parent().get_node(".").start_transition("Living Room", {"mattPos": Vector2(-6510, 0), "mattRight": true})
