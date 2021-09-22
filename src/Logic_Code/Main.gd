extends Node2D

const SceneTwo = preload("res://src/scenes/void.tscn")


func start_transition():
	$TransitionScreen.transition()

func _on_TransitionScreen_transitioned():
	$SceneManager.get_child(0).queue_free()
	$SceneManager.add_child(SceneTwo.instance())
