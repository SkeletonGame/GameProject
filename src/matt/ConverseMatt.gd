extends Area2D

var person_list = []
var person_remove = []
func _on_ConverseMatt_body_entered(body: Node) -> void:
	print("HELLO HHELLO HELLO")
	person_list.add(body.name)

func _on_ConverseMatt_body_exited(body: Node) -> void:
	print("HELLO HHELLO HELLO")
	person_remove.add(body.name)

var person = ""
func _process(delta: float) -> void:
	if person_list.size() > 0:
		person = person_list[person_list.size() - 1]
		print(person)
		if person_remove.size() > 0:
			person_list.erase(person_remove[0])
			person_remove.erase(person_remove[0])
	else:
		person = ""
