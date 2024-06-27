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
var Steps : float
var stepping = 0
@export var WallTouch = 0
#Mach 1 = 150
#Mach 2 = 300
#Mach 3 = 450
#Mach 4 = 600
#Mach 5 = 750

func _physics_process(delta):
	# Handle physics
	if not is_on_floor() or WallTouch == 1:
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
		elif WallTouch == 1 and not Input.is_action_pressed("jump"):
			velocity.y = 250

	if Input.is_action_pressed("crouch"):
		if abs(Speed)> 50 and Input.is_action_just_pressed("crouch"):
			crouch = "S"
			Acceleration = 2
		elif abs(Speed) < 50:
			Acceleration = 12.5
			MaxSpeed = 100
			crouch = "C"
	else:
		crouch = "N"
		if dash == 1:
			MaxSpeed = 750
			Acceleration = 10
		else:
			Acceleration = 12.5
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
	
	floor_snap_length= (((abs(Speed))/32)*2)+24
	
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
					MachTurn = 2
				if MachTurn == 2:
					if not abs(Speed) >= abs(PrevSpeed-10):
						Speed = round(lerpf(roundf(Speed), roundf(-(PrevSpeed+((((int(LR=="L")*2)-1)*10)))), 0.8))
					else:
						Speed= -PrevSpeed
						MachTurn=0
		elif abs(Speed) < MaxSpeed:
			PrevSpeed= Speed + (((int(LR=="R")*2)-1)*50)
			TurnSpeed = 1/(roundf(abs(Speed/100)))
			Speed += Dir*Acceleration
			CtrlLock = 0
			MachTurn = 0
		elif abs(Speed)> 750:
			TurnSpeed = 1/(roundf(abs(Speed/100)))
			PrevSpeed= Speed + (((int(LR=="R")*2)-1)*50)
			Speed = 750* ((int(VelLR == "R")*2)-1)
			MachTurn = 0
	elif is_on_floor() and CtrlLock == "N":
		if dash == 0:
			if abs(Speed) > 5:
				Speed -= Acceleration/1.5 * ((int(VelLR == "R")*2)-1)
			elif not Speed == 0:
				Speed = 0
				MachTurn = 0

	if is_on_floor() or WallTouch == 1:
		if Input.is_action_just_pressed("jump") and (is_on_floor() or WallTouch == 1):
			$Jump.play()
			set_up_direction(Vector2.UP)
			if round(abs(rotation_degrees)) == 90:
				Speed = cos(rotation)*Speed
			elif WallTouch == 1:
				Midair = 10
				print(WallTouch)
				Speed = ((int(LR == "L")*2)-1)*350
				velocity.y = -JumpVel
			else:
				velocity.y= sin(rotation)*Speed
				Speed = cos(rotation)*Speed
			Jump = 1
			Midair = 10
			Speed -= -JumpVel * sin(rotation)
			if WallTouch == 0:
				if not round(abs(rotation_degrees)) == 90:
					velocity.y += -JumpVel * cos(rotation) 
				else:
					velocity.y = -JumpVel*0.8
			rotation=0
	if Input.is_action_just_released("jump") and velocity.y < -200:
		velocity.y = -200

	move_and_slide()

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
	
	
	#Wraps the angle and Slope Physics
	if WallTouch == 0 and is_on_floor_only():
		var normal: Vector2 = get_floor_normal()
		rotation =  lerp_angle(rotation, deg_to_rad(wrapf(rad_to_deg(normal.angle())+90, 180, -180)), .5)
		if ((Speed < 50 and SensorDir == "R" and LR == "R") or (Speed > -50 and SensorDir == "L" and LR == "L")):
			CtrlLock = SensorDir
		else:
			CtrlLock = "N"
		if not roundf(absf((rotation_degrees)/10)) == 0:
			if not CtrlLock == "N":
				Speed -=((int(LR == "R")*2)-1)*10
			elif SensorDir == "U" and dash == 1:
				Speed += sin(round(deg_to_rad(rotation_degrees)))*15
			if not SensorDir == "U" and dash ==1:
				Speed -= sin(round(deg_to_rad(-rotation_degrees)))*13
			else:
				Speed -= sin(round(deg_to_rad(-rotation_degrees)))*18
	else:
		CtrlLock = "N"
	#handles The surface direction, wallrunning, ceiling running all that good sonis stuff
	if (dash == 1 or is_on_floor()):
		if SensorDir == "U" and abs(Speed) < 100:
			set_up_direction(Vector2.UP)
			velocity.y = 50
		if round(rotation_degrees) <= 40 and round(rotation_degrees) >= -40:
			SensorDir = "D"
			set_up_direction(Vector2.UP)
		elif round(rotation_degrees) <= -41 and round(rotation_degrees) >= -129 and WallTouch == 0:
			SensorDir = "R"
			set_up_direction(Vector2.LEFT)
		elif round(rotation_degrees) >= 41 and round(rotation_degrees) <= 129 and WallTouch == 0:
			SensorDir = "L"
			set_up_direction(Vector2.RIGHT)
		elif dash == 1 and WallTouch == 0:
			SensorDir = "U"
			set_up_direction(Vector2.DOWN)
	if dash == 0:
		floor_max_angle=67.5
		if round(abs(rotation_degrees)) > 67.5 or SensorDir == "U":
			if not SensorDir == "U":
				velocity.x = 75 *((int(VelLR=="L")*2)-1)
				velocity.y = 0 
				Speed = 50 *((int(VelLR=="L")*2)-1)
			else:
				set_up_direction(Vector2.UP)
				velocity.y = 75
				Speed = 75 *((int(LR=="L")*2)-1)
	else:
		floor_max_angle=180
#func _process(delta):
	#if is_on_floor():
		#Steps += delta
		#steppering()
		#if stepping == 1 and not $M1Step.playing():
			#$M1Step.play()

func steppering():
	stepping = roundf(sin(Steps*(Speed*.001)) * 1)
	print(stepping)

func roundy1000thee(x):
	return (x *1000)/1

func _is_wall_touch(body):
	print(body.name)
	if body.name == "TileMap":
		WallTouch = 1
	else:
		WallTouch = 0


func _wall_not_touch(body):
	WallTouch = 0
