extends CollisionShape2D

func _on_Mom_body_entered(body: Node) -> void:
	get_parent().get_parent().get_node("Matt").get_node("DialogueLogic").person_list.append(get_parent().name)

func _on_Mom_body_exited(body: Node) -> void:
	get_parent().get_parent().get_node("Matt").get_node("DialogueLogic").person_remove.append(get_parent().name)

var hovered = false # hovered over, this boolean checks if this NPC is the one Matt is currently selecting for dialogue
var speaking = false # this variable will be changed by Matt's code when the dialogue marks this NPC as the speaker
func _process(delta: float) -> void:
	if get_parent().name == get_parent().get_parent().get_node("Matt").get_node("DialogueLogic").person and not get_parent().get_parent().get_node("Matt").get_node("KinematicMatt").motion_lock:
		hovered = true
	else:
		hovered = false
	if not get_parent().get_parent().get_node("Matt").get_node("KinematicMatt").motion_lock:
		speaking = false
		init = false
	get_parent().get_node("Speechable").set_visible(hovered)
<<<<<<< Updated upstream
	get_parent().get_node("Speech Bubble").set_visible(speaking)
=======
	if speaking:
		label_switcher(delta)
		get_parent().get_node("Speech Bubble").set_visible(true)
		if text_display(delta) == "done":
			get_parent().get_parent().get_node("Matt").get_node("AreaMatt").visibility_exception = false
		speaking = false
		if not init:
			dialogue_lines = loadjson("dialogue")[day][get_parent().get_parent().name][get_parent().name]["Dialogues"][String(loadjson("dialogue")[day][get_parent().get_parent().name][get_parent().name]["Interaction_Count"])]
			line_of_dialogue = String(get_parent().get_parent().get_node("Matt").get_node("AreaMatt").line_of_dialogue)
			init = true
	else:
		for this in ["Speech Bubble", "Label1", "Label2"]:
			get_parent().get_node(this).set_visible(false)

var text = ""
var dialogue_lines = {}
var line_of_dialogue = 0
var day = String(1)
func text_display(delta):
	if Input.is_action_just_pressed("interact"):
		if char_time_done:
			line_of_dialogue = int(line_of_dialogue)
			line_of_dialogue += 1
			get_parent().get_parent().get_node("Matt").get_node("AreaMatt").line_of_dialogue = String(line_of_dialogue)
			display_text = ""
		else:
			display_text = text
			char_counter = text.length()
	if String(line_of_dialogue) in dialogue_lines:
		text = dialogue_lines[String(line_of_dialogue)]["Line"]
		if dialogue_lines[String(line_of_dialogue)]["Speaker"] == "Matt":
			return "done"
		else:
			char_time(delta, text)

var label_switch = 0
var switch_timer = 0
func label_switcher(delta):  ## makes the text all animated
	switch_timer += delta  ## make it non-fps based
	if switch_timer > 0.4:
		label_switch += 1
		if label_switch == 2:
			label_switch = 0  ##cycle between the two frames
		switch_timer = 0
		if label_switch:
			get_parent().get_node("Label1").set_visible(true) ## show the label with the first font, 
			get_parent().get_node("Label2").set_visible(false) ## and hide the one with the second
		else:
			get_parent().get_node("Label1").set_visible(false)  ## the same but reversed
			get_parent().get_node("Label2").set_visible(true)

var display_text = ""
var char_counter = 0
var char_timer = 0
var char_time_done = 0
var text_v = ""
var text_speed = 0.047
func char_time(delta, text):  ## make things not all appear at once
	char_timer += delta
	if text_v != text: ## reset if text and text_v (the _v thing means previous, dont ask me, jons a madman)
		display_text = "" ## are mpt the same
		char_counter = 0
		char_timer = 0
		text_v = text
	if char_timer > text_speed and char_counter < text.length(): ## add another letter
		char_time_done = 0
		char_timer = 0
		display_text += text[char_counter]
		char_counter += 1
	if char_counter >= text.length():
		char_time_done = 1
	get_parent().get_node("Label1").set_text(display_text)
	get_parent().get_node("Label2").set_text(display_text)
>>>>>>> Stashed changes
