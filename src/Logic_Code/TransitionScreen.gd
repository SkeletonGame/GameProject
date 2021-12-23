extends CanvasLayer

signal transitioned

var save_scene = ""

func transition(scene):
	$AnimationPlayer.play("fade_to_black") ## fade to black
	save_scene = scene

func _on_AnimationPlayer_animation_finished(anim_name): ## when animation is finished
	if anim_name == "fade_to_black":
		get_parent().SceneNext = load("res://src/scenes/" + save_scene + ".tscn")
		emit_signal("transitioned") ##tell Main to switch scenes
		$AnimationPlayer.play("fade_to_normal") ## fade back in
