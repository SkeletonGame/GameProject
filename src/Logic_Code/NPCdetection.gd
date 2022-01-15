extends CollisionShape2D

func _on_Mom_body_entered(body: Node) -> void:
	get_parent().get_parent().get_node("Matt").get_node("DialogueLogic").person_list.append(get_parent().name)

func _on_Mom_body_exited(body: Node) -> void:
	get_parent().get_parent().get_node("Matt").get_node("DialogueLogic").person_remove.append(get_parent().name)

var hovered = false # hovered over, this boolean checks if this NPC is the one Matt is currently selecting for dialogue
func _process(delta: float) -> void:
	if get_parent().name == get_parent().get_parent().get_node("Matt").get_node("DialogueLogic").person and not get_parent().get_parent().get_node("Matt").get_node("KinematicMatt").motion_lock:
		hovered = true
	else:
		hovered = false
	if hovered:
		get_parent().get_node("Speechable").set_visible(true)
	else:
		get_parent().get_node("Speechable").set_visible(false)
