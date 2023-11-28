extends KinematicBody2D

signal died

enum State { NORMAL, DASHING }

export(int, LAYERS_2D_PHYSICS) var dashHazardMask

var gravity = 550
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 120
var maxDashSpeed = 500
var minDashSpeed = 200
var horizontalAcceleration = 2000
var jumpSpeed = 250
var jumpTerminationMultiplier = 4
var hasdoDubleJump = false
var currentState = State.NORMAL
var isStateNew = true
var defaultHazardMask = 0
var canDash = true
var canDoubleJump = false


func _ready():
	$HazardArea.connect("area_entered", self, "on_hazard_area_entered")
	defaultHazardMask = $HazardArea.collision_mask


func _process(delta):	
	match currentState:
		State.NORMAL:
			proccess_normal(delta)
		State.DASHING:
			proccess_dash(delta)
	isStateNew = false


func change_state(newState):
	currentState = newState
	isStateNew = true
	

func proccess_normal(delta):
	if(isStateNew) :
		$DashArea/CollisionShape2D.disabled = true		
		$HazardArea.collision_mask = defaultHazardMask
		
	var moveVector = get_movement_vector()
	
	velocity.x += moveVector.x * horizontalAcceleration * delta
	
	if(moveVector.x == 0) :
		velocity.x = lerp(0, velocity.x, pow(2, -15 * delta))
		
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	if(moveVector.y < 0 and (is_on_floor() or ! $CoyoteTimer.is_stopped() or (hasdoDubleJump and canDoubleJump))):
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
		canDash = true
		
	if(Input.is_action_just_pressed("dash") and canDash and is_on_floor()):
		call_deferred("change_state", State.DASHING)
		canDash = false
	
	update_animation()
	update_sprite_direction()


func proccess_dash(delta):
	if(isStateNew):		
		$DashArea/CollisionShape2D.disabled = false		
		$AnimatedSprite.play("jump")
		$HazardArea.collision_mask = dashHazardMask
		var moveVector = get_movement_vector()
		var velocityMod = 1
		if(moveVector.x != 0):
			velocityMod = sign(moveVector.x)
		else:
			velocityMod = 1 if $AnimatedSprite.flip_h else -1
					
		velocity = Vector2(maxDashSpeed * velocityMod, 0)
			
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(0, velocity.x, pow(2, -10 * delta))
	
	if(abs(velocity.x) < minDashSpeed):
		call_deferred("change_state", State.NORMAL)


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
		

func on_hazard_area_entered(_area2D):
	emit_signal("died")
	print("die")
