extends Area2D

func _on_DialogueArea_body_entered(body: Node) -> void:
	get_parent().get_node("DialogueLogic").person_list.append(body.name)

func _on_DialogueArea_body_exited(body: Node) -> void:
	get_parent().get_node("DialogueLogic").person_remove.append(body.name)

var mattPos
func area_follow(delta):
	mattPos = get_parent().get_node("KinematicMatt").mattPosition
	position = mattPos

func _process(delta: float) -> void:
	area_follow(delta)
