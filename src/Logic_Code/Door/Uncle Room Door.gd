extends Area2D

var hovered = false
func _on_Uncle_Room_Door_body_entered(body: Node) -> void:
	hovered = true

func _on_Uncle_Room_Door_body_exited(body: Node) -> void:
	hovered = false

func _process(delta: float) -> void:
	get_node("Doorable").visible = hovered
	if hovered and Input.is_action_just_pressed("interact"):
		get_parent().get_parent().get_parent().get_node(".").start_transition("Uncle Bedroom")
