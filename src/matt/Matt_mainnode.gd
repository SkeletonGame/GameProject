extends Node2D

signal ayo

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("my_signal")


