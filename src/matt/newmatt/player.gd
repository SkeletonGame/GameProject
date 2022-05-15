extends KinematicBody2D
class_name Player

enum Direction {
  right,
  left,
  none
}

var direction = Direction.none

var jump = false
var velocity = Vector2.ZERO
var grav = 100

func phys_handler(delta):
	grav = 100
	var body
	body = move_and_collide(velocity * delta);
	var bodyname = null
	if body: 
		bodyname = body.collider.name
		print ()
		grav = 0
		velocity.y = 0
	
	velocity.x += Input.get_action_strength("right") * 7000 * delta
	velocity.x += Input.get_action_strength("left") * -7000 * delta
	velocity.x *= 0.88
	
	if not jump:
		velocity.y += grav
	if velocity.x > 150:
		direction = Direction.right
	elif velocity.x < -150:
		direction = Direction.left
	else:
		direction = Direction.none
