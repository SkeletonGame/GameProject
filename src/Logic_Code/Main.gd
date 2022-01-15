extends Node2D

var SceneNext = ""

var info = {}
func start_transition(scene, add_info = {}):
	$TransitionScreen.transition(scene)
	if add_info != {}:
		info = add_info
		info["scene"] = scene
	else:
		info = {}

func _on_TransitionScreen_transitioned():
	$SceneManager.get_child(0).queue_free()
	$SceneManager.add_child(SceneNext.instance())
	if info != {}:
		if "mattPos" in info:
			get_node("SceneManager").get_node(info["scene"]).get_node("Matt").get_node("KinematicMatt").position = info["mattPos"]
		if "mattSpeak" in info:
			get_node("SceneManager").get_node(info["scene"]).get_node("Matt").get_node("AreaMatt").directInput = info["mattSpeak"]
		if "mattRight" in info:
			get_node("SceneManager").get_node(info["scene"]).get_node("Matt").get_node("KinematicMatt").direction = "right"
	## once the fade to black transition is finished, switch scenes.
