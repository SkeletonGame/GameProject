extends Area2D

func _on_Arena_body_exited(body: Node) -> void:
	pass
	get_parent().get_node(body.name).dead = true
