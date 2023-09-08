extends KinematicBody2D

var gravity = 550
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 120
var horizontalAcceleration = 2000
var jumpSpeed = 250
var jumpTerminationMultiplier = 4
var hasdoDubleJump = false

func _process(delta):	
	var moveVector = get_movement_vector()
	
	velocity.x += moveVector.x * horizontalAcceleration * delta
	
	if(moveVector.x == 0) :
		velocity.x = lerp(0, velocity.x, pow(2, -15 * delta))
		
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	if(moveVector.y < 0 and (is_on_floor() or ! $CoyoteTimer.is_stopped() or hasdoDubleJump)):
		velocity.y = moveVector.y * jumpSpeed
		if( ! is_on_floor() and $CoyoteTimer.is_stopped()):
			hasdoDubleJump = false
		$CoyoteTimer.stop()
		
	if(velocity.y < 0 and ! Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
		
	var wasOnFloor = is_on_floor()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if(wasOnFloor and ! is_on_floor()):
		$CoyoteTimer.start()
		
	if(is_on_floor()):
		hasdoDubleJump = true
	
	update_animation()
	update_sprite_direction()
	

func get_movement_vector():
	var moveVector = Vector2.ZERO	
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return moveVector
	

func update_animation():
	var moveVec = get_movement_vector()
	if( ! is_on_floor()):
		$AnimatedSprite.play("jump")
	elif(moveVec.x != 0):
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")


func update_sprite_direction():
	if(Input.get_action_strength("move_right")):
		$AnimatedSprite.flip_h = true
	if(Input.get_action_strength("move_left")):	
		$AnimatedSprite.flip_h = false
