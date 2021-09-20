extends Area2D

var speech_visible = 0
var label_switch = 0
var switch_timer = 0
func label_switcher(delta):
	switch_timer += delta
	if switch_timer > 0.4:
		label_switch += 1
		if label_switch == 2:
			label_switch = 0
		switch_timer = 0
		if label_switch:
			get_node("Speech Bubble/Label1").set_visible(true)
			get_node("Speech Bubble/Label2").set_visible(false)
		else:
			get_node("Speech Bubble/Label1").set_visible(false)
			get_node("Speech Bubble/Label2").set_visible(true)

var display_text = ""
var char_counter = 0
var char_timer = 0
func char_time(delta, text):
	char_timer += delta
	if char_timer > 0.08 and char_counter < text.length():
		char_timer = 0
		display_text += text[char_counter]
		char_counter += 1
	get_node("Speech Bubble/Label1").set_text(display_text)
	get_node("Speech Bubble/Label2").set_text(display_text)

var text = "Big Big Chungus"
var mattPos = Vector2.ZERO
func text_handler(delta):
	if speech_visible:
		label_switcher(delta)
		char_time(delta, text)
	else:
		get_node("Speech Bubble/Bubble").set_visible(false)
		get_node("Speech Bubble/Label2").set_visible(false)
		get_node("Speech Bubble/Label1").set_visible(false)

func area_follow(delta):
	mattPos = get_parent().get_node("KinematicMatt").mattPosition
	position = mattPos

func _physics_process(delta: float) -> void:
	text_handler(delta)
	area_follow(delta)
