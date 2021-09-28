extends Node2D

var SceneNext = ""


func start_transition(scene):
	$TransitionScreen.transition()
	SceneNext = load("res://src/scenes/" + scene + ".tscn")

func _on_TransitionScreen_transitioned():
	$SceneManager.get_child(0).queue_free()
	$SceneManager.add_child(SceneNext.instance())
