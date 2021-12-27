extends CollisionShape2D

var wait = 0
var is_on_slope = false
var dis = false

var railing_order = 4 # order of the railing in the scene

func fallThrough():
	is_on_slope = get_parent().get_parent().get_node("Matt").get_node("KinematicMatt").surface_property == "slope"
	if Input.is_action_pressed("down") and Input.is_action_just_pressed("space") and is_on_slope: ##if down and jump is pressed
		if get_parent().get_parent().has_node("Matt"):
			get_parent().get_parent().get_node("Matt").get_node("KinematicMatt").surface_property = "default"
		dis = true
		get_parent().get_parent().move_child(get_parent().get_parent().get_node("railing"), railing_order - 1)

func check_dis():
	disabled = dis

func _process(delta: float) -> void:
	fallThrough()
	check_dis()

func _on_On_body_entered(body: Node) -> void:
	dis = false
	get_parent().get_parent().move_child(get_parent().get_parent().get_node("railing"), railing_order)

func _on_Off_body_entered(body: Node) -> void:
	dis = true
	get_parent().get_parent().move_child(get_parent().get_parent().get_node("railing"), railing_order - 1)
