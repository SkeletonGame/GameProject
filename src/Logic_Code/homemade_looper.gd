extends AudioStreamPlayer2D

var loop = true
func _process(delta: float) -> void:
	if loop and not playing:
		playing = true
	elif not loop:
		playing = false

func _on_Garage_CowboyInterruption() -> void:
	loop = false
