extends Node2D
class_name Maus

var mx = 0
var my = 0
func _process(_delta):
	mx = get_viewport().get_mouse_position()[0]
	my = get_viewport().get_mouse_position()[1]

var m1 = 0
var m2 = 0
var m1_t = 0
var m2_t = 0
func _input(event):
	m1_t = 0
	m2_t = 0
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			m1 = 1
			m1_t = 1
		else:
			m1 = 0
		if event.button_index == BUTTON_RIGHT and event.pressed:
			m2 = 1
			m2_t = 1
		else:
			m2 = 0
		
