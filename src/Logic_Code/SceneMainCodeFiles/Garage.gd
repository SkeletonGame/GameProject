extends Node2D

signal CowboyInterruption

func _on_In_Front_of_TV_body_entered(body: Node) -> void:
	emit_signal("CowboyInterruption")
