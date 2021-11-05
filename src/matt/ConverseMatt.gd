extends Area2D

var person = ""
func _on_ConverseMatt_body_entered(body: Node) -> void:
	person = body.name

func _on_ConverseMatt_body_exited(body: Node) -> void:
	person = ""
