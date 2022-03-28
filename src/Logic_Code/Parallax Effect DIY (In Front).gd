extends Node2D

var x_change = 0
var y_change = 0
var pos = [position.x, position.y]

func _process(delta: float) -> void:
	set_position(Vector2(position.x + x_change, position.y + y_change))
