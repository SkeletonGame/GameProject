extends AnimatedSprite

func _on_Garage_CowboyInterruption() -> void:
	if get_node("cowboy stuff").jessieplaying == true:
		get_node("cowboy stuff").get_node("yeehaw").volume_db -= 10
		get_node("cowboy stuff").jessieplaying = false
