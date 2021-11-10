extends Area2D

func loadjson(filename):
	var file = File.new()
	file.open("datafiles/" + filename + ".json", file.READ)  ## read json files
	var data = {}
	var text = file.get_as_text()
	data = parse_json(text)
	file.close()
	return data ## return data

var speech_visible = 1
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
			get_node("Speech Bubble/Label1").set_visible(true) ## show the label with the first font, 
			get_node("Speech Bubble/Label2").set_visible(false) ## and hide the one with the second
		else:
			get_node("Speech Bubble/Label1").set_visible(false)  ## the same but reversed
			get_node("Speech Bubble/Label2").set_visible(true)

var display_text = ""
var char_counter = 0
var char_timer = 0
var char_time_done = 0
var text_v = ""
var text_speed = 0.045
func char_time(delta, text):  ## make things not all appear at once
	char_timer += delta
	if text_v != text: ## reset if text and text_v (the _v thing means previous, dont ask me, jons a madman)
		display_text = "" ## are mpt the same
		char_counter = 0
		char_timer = 0
		text_v = text
	if char_timer > text_speed and char_counter < text.length(): ## print another letter
		char_time_done = 0
		char_timer = 0
		display_text += text[char_counter]
		char_counter += 1
	if char_counter >= text.length():
		char_time_done = 1
	get_node("Speech Bubble/Label1").set_text(display_text)
	get_node("Speech Bubble/Label2").set_text(display_text)

var option_list = []
var option_count = 0
var decision_init = 1
var flag_type = ""
var flag_data = ""
func decision_maker(): # dont worry about this function, it works
	get_node("Speech Bubble/circles").set_visible(true)
	option_list = dialogue_lines[line_of_dialogue]["Options"]
	if decision_init:
		get_node("Speech Bubble/circles/" + String(option_list.size()) + "option/circles1").set_animation("idle")
		get_node("Speech Bubble/circles/" + String(option_list.size()) + "option/circles2").set_animation("idle")
		if option_list.size() > 2:
			get_node("Speech Bubble/circles/" + String(option_list.size()) + "option/circles3").set_animation("idle")
		if option_list.size() > 3:
			get_node("Speech Bubble/circles/" + String(option_list.size()) + "option/circles4").set_animation("idle")
		decision_init = 0
		option_count = 0
		get_node("Speech Bubble/circles/" + String(option_list.size()) + "option/circles" + String(option_count + 1)).set_animation("filled")
	for i in ["Speech Bubble/circles/2option", "Speech Bubble/circles/3option", "Speech Bubble/circles/4option"]:
		get_node(i).set_visible(false)
	if Input.is_action_just_pressed("right") and option_count < option_list.size() - 1:
		get_node("Speech Bubble/circles/" + String(option_list.size()) + "option/circles" + String(option_count + 1)).set_animation("idle")
		option_count += 1
		get_node("Speech Bubble/circles/" + String(option_list.size()) + "option/circles" + String(option_count + 1)).set_animation("filled")
	if Input.is_action_just_pressed("left") and option_count > 0:
		get_node("Speech Bubble/circles/" + String(option_list.size()) + "option/circles" + String(option_count + 1)).set_animation("idle")
		option_count -= 1
		get_node("Speech Bubble/circles/" + String(option_list.size()) + "option/circles" + String(option_count + 1)).set_animation("filled")
	get_node("Speech Bubble/circles/" + String(option_list.size()) + "option").set_visible(true)
	if "Flag" in option_list[option_count]:
		flag_type = option_list[option_count]["Flag"].split("_")[0]
		flag_data = option_list[option_count]["Flag"].split("_")[1]
	else:
		flag_type = ""
		flag_data = ""
	return option_list[option_count]["OP_Line"] # OP_Line = option line

var file = ""
var dialogue_lines = {}
var line_of_dialogue = 0
var emotion = "idle"
var text_getter_counter = 0
func text_getter(delta, inter_arg): # inter_arg = interactable_argument
	text_getter_counter += delta
	if Input.is_action_just_pressed("interact"):
		if char_time_done:
			line_of_dialogue = int(line_of_dialogue)
			line_of_dialogue += 1
			display_text = ""
		else:
			display_text = text
			char_counter = text.length()
	if speech_type == "interaction":
		file = loadjson("interactables")
		if inter_arg in file:
			dialogue_lines = file[inter_arg]["Dialogue_Lines"]
			line_of_dialogue = String(line_of_dialogue) # line of dialogue is the NUMBER of the line currently observed.
			if line_of_dialogue in dialogue_lines:  # if the line of dialogue number is greater than the number of lines for a dialogue, then the dialogue ends
				if "Emotion" in dialogue_lines[line_of_dialogue]:
					emotion = dialogue_lines[line_of_dialogue]["Emotion"]
				else:
					emotion = "idle"
				if "Line" in dialogue_lines[line_of_dialogue]:
					option_list = [] # this list NEEDS to be reset for the options to work. it resets when there isnt options.
					flag_type = ""
					flag_data = ""
					return dialogue_lines[line_of_dialogue]["Line"]
				elif "Options" in dialogue_lines[line_of_dialogue]:
					if option_list.size() < 1:
						decision_init = 1
					return decision_maker()
			else:
				get_parent().get_node("KinematicMatt").motion_lock = false
				emotion = "idle"
				speech_interactable = ""
				speech_trigger = 0
				line_of_dialogue = 0
				if flag_type == "MG": # minigame
					get_parent().get_parent().get_parent().get_parent().get_node(".").start_transition("minigames/" + flag_data)
				return ""
	elif speech_type == "dialogue":
		file = loadjson("dialogue")
		pass

var text = ""
var interactable = ""
var person = ""
var speech_trigger = 0
var speech_interactable = ""
var temp_interactable = interactable
var temp_person = person
var speech_type = "" ## interaction or conversation. this determines a few ways the code happens
func text_processer(delta):
	interactable = get_parent().get_node("KinematicMatt").touched
	if interactable != temp_interactable and not temp_interactable == "":
		get_parent().get_parent().get_node(temp_interactable).get_node("interactable").set_visible(false)
		temp_interactable = ""
	if interactable != "":
		temp_interactable = interactable
		get_parent().get_parent().get_node(interactable).get_node("interactable").set_visible(true) ##if interactable show the eye
		if Input.is_action_just_pressed("interact"):
			get_parent().get_node("KinematicMatt").motion_lock = true ##stop player movement
			speech_trigger = 1
			speech_interactable = interactable
			speech_type = "interaction"
	person = get_parent().get_node("DialogueLogic").person
	if person != "":
		speech_trigger = 1
		speech_interactable = person
		speech_type = "dialogue"
	if speech_trigger:
		text = text_getter(delta, speech_interactable) ## get diologue 
		dialogue_lines = {}
	if text == "":
		speech_visible = 0
		display_text = ""
		char_counter = 0
		char_timer = 0
		char_time_done = 0
	else:
		speech_visible = 1

var mattPos = Vector2.ZERO
func text_handler(delta):
	text_processer(delta)
	if speech_visible:
		get_node("Speech Bubble").set_visible(true) ## speech bubble moment
		if option_list.size() > 0:
			get_node("Speech Bubble/circles").set_visible(true)
		else:
			get_node("Speech Bubble/circles").set_visible(false)
		label_switcher(delta)
		char_time(delta, text)
	else:
		get_node("Speech Bubble").set_visible(false)

func area_follow(delta):
	mattPos = get_parent().get_node("KinematicMatt").mattPosition
	position = mattPos

func _physics_process(delta: float) -> void:
	text_handler(delta)
	area_follow(delta)
