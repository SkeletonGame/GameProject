extends CanvasLayer

signal transitioned

func transition():
	$AnimationPlayer.play("fade_to_black") ## fade to black

func _on_AnimationPlayer_animation_finished(anim_name): ## when animation is finished
	if anim_name == "fade_to_black":
		emit_signal("transitioned") ##tell Main to switch scenes
		$AnimationPlayer.play("fade_to_normal") ## fade back in
