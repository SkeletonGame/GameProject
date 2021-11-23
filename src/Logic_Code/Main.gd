extends Node2D

var SceneNext = ""

func scenefile_dir(path):
	var files = []
	var dir = Directory.new()
	print(path)
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.get_extension() == "tscn":
			files.append(file)
	dir.list_dir_end()
	return files

var scene_list = [] # a list of string names of all scenes in the scenes folder
var mgscene_list = [] # a list of string names of all scenes in the minigame folder
var scene_dict = {} # a dictionary: key is string name and value is preloaded scene
func _ready():
	scene_list = scenefile_dir("res://src//scenes")
	for this in scene_list:
		scene_dict[this] = load("res://src/scenes/" + this)
	mgscene_list = scenefile_dir("res://src//scenes//minigames")
	
	## UNFINISHED CODE ABOVE! I will get to it later im tired lmao

var info = {}
func start_transition(scene, add_info = {}):
	$TransitionScreen.transition()
	if add_info != {}:
		info = add_info
		info["scene"] = scene
	else:
		info = {}
	SceneNext = load("res://src/scenes/" + scene + ".tscn")
	## loads the scene defined as scene

func _on_TransitionScreen_transitioned():
	$SceneManager.get_child(0).queue_free()
	$SceneManager.add_child(SceneNext.instance())
	if info != {}:
		if "mattPos" in info:
			get_node("SceneManager").get_node(info["scene"]).get_node("Matt").get_node("KinematicMatt").position = info["mattPos"]
		if "mattSpeak" in info:
			get_node("SceneManager").get_node(info["scene"]).get_node("Matt").get_node("AreaMatt").directInput = info["mattSpeak"]
	## once the fade to black transition is finished, switch scenes.
