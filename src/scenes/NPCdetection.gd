extends CollisionShape2D


func _on_Mom_body_entered(body: Node) -> void:
	get_parent().get_parent().get_node("Matt").get_node("DialogueLogic").person_list.append(get_parent().name)

func _on_Mom_body_exited(body: Node) -> void:
	get_parent().get_parent().get_node("Matt").get_node("DialogueLogic").person_remove.append(get_parent().name)
