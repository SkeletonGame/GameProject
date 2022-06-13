extends KinematicBody2D

var velocity_power = 0
var velocity = Vector2(0, 0)
var dead = false

func _process(delta):
	velocity[0] += cos(rotation_degrees / 360 * 2 * PI) * velocity_power
	velocity[1] += sin(rotation_degrees / 360 * 2 * PI) * velocity_power
	move_and_slide(velocity)
	if dead:
		queue_free()

func _on_Area2D_area_exited(area):
	dead = true

func _on_Area2D_body_entered(body):
	body.speed += velocity * 5
	velocity_power *= 0.5
