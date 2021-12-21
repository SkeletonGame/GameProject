extends CollisionShape2D

var count = 0
var wait = 0

func fallThrough(delta):
	count += delta
	if Input.is_action_pressed("down") and Input.is_action_just_pressed("space"): ##if down and jump is pressed
		if get_parent().get_parent().has_node("Matt"):
			get_parent().get_parent().get_node("Matt").get_node("KinematicMatt").surface_property = "default"
		disabled = true
		wait = count
	if disabled and count > wait + 1: ##fall through floor
		disabled = false

func walkUnder():
	pass

func _process(delta: float) -> void:
	fallThrough(delta)
	walkUnder()
