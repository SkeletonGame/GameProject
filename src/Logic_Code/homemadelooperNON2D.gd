extends AudioStreamPlayer

var loop = true
func _process(delta: float) -> void:
	if loop and not playing:
		playing = true
	elif not loop:
		playing = false
