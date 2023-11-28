extends KinematicBody2D

var max_speed = 100
var velocity = Vector2.ZERO
var direction = Vector2.RIGHT

func _process(delta):
	velocity.x = (direction * max_speed).x
	velocity = move_and_slide(velocity, Vector2.UP)
	
	$AnimatedSprite.flip_h = true if direction.x > 0 else false
	
