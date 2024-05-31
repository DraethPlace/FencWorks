extends CharacterBody2D

@export var LR = "R"
@export var Acceleration = 10
@export var MaxSpeed = 200.0
@export var JumpVel = 650.0
@export var SensorDir = "D"
@export var FallVel = 0
@export var Speed = 0
@export var Midair = 0
@export var Jump = 0
@export var MachTurn = 0
var CtrlLock = 0
var dash = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var VelLR = "R"
var crouch = "N"
var PrevSpeed= Speed
var TurnSpeed = Speed
var HoldTimer: Timer
#Mach 1 = 150
#Mach 2 = 250
#Mach 3 = 350
#Mach 4 = 500
#Mach 5 = 600

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

	if Input.is_action_pressed("crouch"):
		if abs(Speed)> 50 and Input.is_action_just_pressed("crouch"):
			crouch = "S"
			Acceleration = 2
		elif abs(Speed) < 50:
			Acceleration = 15
			MaxSpeed = 100
			crouch = "C"
	else:
		crouch = "N"
		if dash == 1:
			MaxSpeed = 600
			Acceleration = 10
		else:
			Acceleration = 15
			MaxSpeed = 200

	if Input.is_action_pressed("machdash"):
		dash = 1
	else:
		dash = 0
	#Direction facing
	if Speed == 0:
		LR = LR
	elif Speed < 0 and Input.is_action_pressed("left"):
		LR = "L"
	elif Speed > 0 and Input.is_action_pressed("right"):
		LR = "R"

	if Speed == 0:
		VelLR = VelLR
	elif Speed < 1:
		VelLR = "L"
	elif Speed > -1:
		VelLR = "R"
	
	floor_snap_length= (((abs(Speed))/32)*2)+20
	
	# Code for changing speed around
	var Dir = Input.get_axis("left", "right")
	if Dir and ((CtrlLock == "L" and Input.is_action_pressed("right")) or (CtrlLock == "R" and Input.is_action_pressed("left")) or (CtrlLock == "N")) and not crouch == "S":
		if (not (Speed/(abs(Speed)*Dir)) == 1) and abs(Speed)> 50:
			if dash == 0:
				Speed +=  Dir*Acceleration*2
				CtrlLock = 0
			if dash == 1:
				if MachTurn == 0:
					PrevSpeed = Speed + (((int(LR=="R")*2)-1)*50)
					TurnSpeed = 1/(roundf(abs(Speed/100)))
					MachTurn = 1
				else:
					CtrlLock = "N"
					Speed = (lerpf(roundf(Speed), roundf(PrevSpeed*0.5), TurnSpeed))
				if abs(Speed) <= abs(PrevSpeed*0.5)+3:
					Speed = -PrevSpeed
					for i in 10:
						MachTurn = 0
		elif abs(Speed) < MaxSpeed:
			Speed += Dir*Acceleration
			CtrlLock = 0
		elif abs(Speed)> 600:
			Speed = 600* ((int(VelLR == "R")*2)-1)
	elif is_on_floor() and CtrlLock == "N":
		if dash == 0:
			if abs(Speed) > 5:
				Speed -= Acceleration/1.5 * ((int(VelLR == "R")*2)-1)
			elif not Speed == 0:
				Speed = 0
				MachTurn = 0
	print(Speed)
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
	
	#Wraps the angle and Slope Physics
	if is_on_floor():
		var normal: Vector2 = get_floor_normal()
		rotation =  lerp_angle(rotation, deg_to_rad(wrapf(rad_to_deg(normal.angle())+90, 180, -180)), .5)
		if ((Speed < 50 and SensorDir == "R" and LR == "R") or (Speed > -50 and SensorDir == "L" and LR == "L")):
			CtrlLock = SensorDir
		else:
			CtrlLock = "N"
		if not roundf(absf((rotation_degrees)/10)) == 0:
			if not CtrlLock == "N":
				Speed -=((int(LR == "R")*2)-1)*10
			elif SensorDir == "U":
				Speed += sin(round(rotation))*((int(dash== 0))+1)*10
			elif SensorDir == LR:
				Speed -= (sin(round(deg_to_rad(-rotation_degrees)))*((int(dash== 0))+1)*10)
			elif SensorDir == "L" or SensorDir == "R":
				Speed -= sin(round(deg_to_rad(-rotation_degrees)))*((int(dash== 0))+1)*10
			else:
				Speed -= sin(round(deg_to_rad(-rotation_degrees))*((int(dash== 0))+1)*10)
	else:
		CtrlLock = "N"
	#handles The surface direction, wallrunning, ceiling running all that good sonis stuff

	if SensorDir == "U" and abs(Speed) < 100:
		set_up_direction(Vector2.UP)
		velocity.y = 50

	if round(rotation_degrees) <= 40 and round(rotation_degrees) >= -40:
		SensorDir = "D"
		set_up_direction(Vector2.UP)
	elif round(rotation_degrees) <= -41 and round(rotation_degrees) >= -129:
		SensorDir = "R"
		set_up_direction(Vector2.LEFT)
	elif round(rotation_degrees) >= 41 and round(rotation_degrees) <= 129:
		SensorDir = "L"
		set_up_direction(Vector2.RIGHT)
	elif dash == 1:
		SensorDir = "U"
		set_up_direction(Vector2.DOWN)
	if dash == 0:
		floor_max_angle=67.5
		if round(abs(rotation_degrees)) > 67.5 or SensorDir == "U":
			if not SensorDir == "U":
				velocity.x = 75 *((int(LR=="L")*2)-1)
				Speed = 0
				
			else:
				set_up_direction(Vector2.UP)
				velocity.y = 75
	else:
		floor_max_angle=180

