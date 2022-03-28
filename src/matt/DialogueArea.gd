extends Area2D

func _on_DialogueArea_body_entered(body: Node) -> void:
	get_parent().get_node("DialogueLogic").person_list.append(body.name)
	print(body.name)

func _on_DialogueArea_body_exited(body: Node) -> void:
	get_parent().get_node("DialogueLogic").person_remove.append(body.name)
