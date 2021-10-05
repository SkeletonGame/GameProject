extends Node2D

var SceneNext = ""


func start_transition(scene):
	$TransitionScreen.transition()
	SceneNext = load("res://src/scenes/" + scene + ".tscn")
	## loads the scene defined as scene

func _on_TransitionScreen_transitioned():
	$SceneManager.get_child(0).queue_free()
	$SceneManager.add_child(SceneNext.instance())
	## once the fade to black transition is finished, switch scenes.
