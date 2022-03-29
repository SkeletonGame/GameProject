extends AudioStreamPlayer2D

var voice
func _ready() -> void:
	voice = load("res://noises/voice/Matt.wav")
	stream = voice

var mattPos
func voice_follow(delta):
	mattPos = get_parent().get_node("KinematicMatt").mattPosition
	position = mattPos

func _process(delta: float) -> void:
	voice_follow(delta)
