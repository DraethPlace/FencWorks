extends CharacterBody2D

@export var LR = "R"
@export var Acceleration = 8
@export var MaxSpeed = 500.0
@export var JumpVel = 650.0
@export var SensorDir = "D"
@export var FallVel = 0
@export var Speed = 0
@export var Midair = 0
@export var Jump = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Handle physics
	if not is_on_floor():
		if Midair <1:
			velocity.y= sin(rotation)*Speed
			Speed= cos(rotation)*Speed
		Midair += 1
		if Midair >4:
			set_up_direction(Vector2.UP)
			velocity.y += (gravity * delta)
			if velocity.y > 19000 and not is_on_floor():
				velocity.y = 19000
			if not rotation == 0:
				rotation = lerp_angle(rotation, 0, 0.2)
		
	#Direction facing
	if Speed == 0:
		LR = LR
	elif Speed < 0:
		LR = "L"
	elif Speed > 0:
		LR = "R"
	# Code for changing speed around
	var Dir = Input.get_axis("left", "right")
	if Dir:
		if not (Speed/(abs(Speed)*Dir)) == 1:
			Speed +=  Dir*Acceleration*2.5
		elif abs(Speed) < MaxSpeed:
			Speed += Dir*Acceleration
	else:
		if is_on_floor():
			if abs(Speed)> 4:
				Speed -= Acceleration/1.5 * ((int(LR == "R")*2)-1)
			else:
					Speed = 0
	
	if is_on_floor():
		#actually moves player
		if SensorDir == "D":
			velocity.x = Speed
		elif SensorDir == "U":
			velocity.x = -Speed
		elif SensorDir == "R":
			velocity.y = -Speed
		elif SensorDir == "L":
			velocity.y = Speed
		if Midair > 0:
			Midair -= 5
		else:
			Midair=0
	elif Midair >= 10:
		velocity.x= Speed
	#jumping
	if is_on_floor():
		if Input.is_action_just_pressed("jump") and is_on_floor():
			set_up_direction(Vector2.UP)
			Speed = cos(rotation)*Speed
			velocity.y= sin(rotation)*Speed
			Jump = 1
			Midair = 10
			Speed += -JumpVel * cos(deg_to_rad(rotation_degrees+90))
			velocity.y += -JumpVel * cos(rotation)
			rotation=0
	if Input.is_action_just_released("jump") and velocity.y < -200:
		velocity.y = -200
	move_and_slide()
	
	#Wraps the angle 
	if is_on_floor():
		var normal: Vector2 = get_floor_normal()
		rotation_degrees =  wrapf(rad_to_deg(normal.angle())+90, 180, -180)

	#handles The surface direction, wallrunning, ceiling running all that good sonis stuff
	if rotation_degrees < 45 and rotation_degrees > -45:
		SensorDir = "D"
		set_up_direction(Vector2.UP)
	elif rotation_degrees < 135 and rotation_degrees > 45:
		SensorDir = "L"
		set_up_direction(Vector2.RIGHT)
	elif rotation_degrees < -45 and rotation_degrees > -135:
		SensorDir = "R"
		set_up_direction(Vector2.LEFT)
	else:
		SensorDir = "U"
		set_up_direction(Vector2.DOWN)
