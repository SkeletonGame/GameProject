extends Node2D

# this is just to keep the duck scene in the garage scene, it will be immediately destroyed
func _ready() -> void:
	queue_free()
