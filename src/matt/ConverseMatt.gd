extends Node

var person_list = []
var person_remove = []

var person = ""
func _process(delta: float) -> void:
	if person_list.size() > 0:
		person = person_list[person_list.size() - 1]
		if person_remove.size() > 0:
			person_list.erase(person_remove[0])
			person_remove.erase(person_remove[0])
	else:
		person = ""
