extends AnimatedSprite

func _on_Garage_CowboyInterruption() -> void:
	get_node("cowboy stuff").jessieplaying = false
	get_node("cowboy stuff").get_node("yeehaw").volume_db -= 10
