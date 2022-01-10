extends Area2D

func _on_CameraInL_body_exited(body: Node) -> void:
	get_parent().get_parent().get_node("Matt").get_node("CameraLogic").new = "x1"
