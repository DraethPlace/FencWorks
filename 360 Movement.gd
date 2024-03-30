extends CharacterBody2D

@export var LR = "R"
@export var Acceleration = 8
@export var MaxSpeed = 500.0
@export var JumpVel = 650.0
@export var SensorDir = "h"
@export var FallVel = 0
@export var Speed = 0
@export var Midair = 0
@export var Jump = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):

	if not is_on_floor():
		SensorDir="D"
		if Midair == 5 and Jump == 0:
			velocity.y = cos(deg_to_rad(rotation_degrees+90))*Speed*-1
			Speed = sin(deg_to_rad(rotation_degrees+90))*Speed
		if Midair > 10 and Jump == 0:
			rotation = 0
	if is_on_floor() and Midair > 0:
		Midair -= 1
	
	if not is_on_floor():
		Midair += 1
	if SensorDir == "D":
		set_up_direction(Vector2.UP)
		velocity.y += (gravity * delta)
		if velocity.y > 19000 and not is_on_floor():
			velocity.y = 19000
	elif SensorDir == "U":
		set_up_direction(Vector2.DOWN)
		velocity.y += (gravity * delta)*-1
	elif SensorDir == "R":
		set_up_direction(Vector2.LEFT)
		velocity.x += (gravity * delta)*1
	elif SensorDir == "L":
		set_up_direction(Vector2.RIGHT)
		velocity.x += (gravity * delta)*-1
	
	var forward = Vector2.from_angle(rotation)
	if Speed == 0:
		LR = LR
	elif Speed < 0:
		LR = "L"
	elif Speed > 0:
		LR = "R"
	
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
	if is_on_floor() and Midair < 5:
		velocity= forward * Speed
		Midair = 0
		Jump = 0
		if SensorDir == "D":
			velocity.y += 25
		elif SensorDir == "U":
			velocity.y -= 25
		elif SensorDir == "R":
			velocity.x += 25
		elif SensorDir == "L":
			velocity.x -= 25
	else:
		velocity.x = Speed
	if is_on_floor():
		if Input.is_action_just_pressed("jump") and is_on_floor():
			Jump = 1
			Midair = 10
			Speed += -JumpVel * cos(rotation+1.5707963267949)
			velocity.y += -JumpVel * cos(rotation)
			rotation=0
	if Input.is_action_just_released("jump") and velocity.y < -200:
		velocity.y = -200
	move_and_slide()

	if is_on_floor():
		var normal: Vector2 = get_floor_normal()
		rotation_degrees =  wrapf(rad_to_deg(normal.angle())+90, 180, -180)

	if rotation_degrees < 45 and rotation_degrees > -45:
		SensorDir = "D"
	elif rotation_degrees < 135 and rotation_degrees > 45:
		SensorDir = "L"
	elif rotation_degrees < -45 and rotation_degrees > -135:
		SensorDir = "R"
	else:
		SensorDir = "U"
	print(Midair)
