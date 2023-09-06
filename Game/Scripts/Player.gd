extends KinematicBody2D

var gravity = 550
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 120
var horizontalAcceleration = 2000
var jumpSpeed = 250
var jumpTerminationMultiplier = 4

func _process(delta):
	var moveVector = Vector2.ZERO
	
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	
	velocity.x += moveVector.x * horizontalAcceleration * delta
	if(moveVector.x == 0) :
		velocity.x = lerp(0, velocity.x, pow(2, -15 * delta))
		
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	if(moveVector.y < 0 and is_on_floor()):
		velocity.y = moveVector.y * jumpSpeed
		
	if(velocity.y < 0 and ! Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)