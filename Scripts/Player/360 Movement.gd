extends CharacterBody2D

@export var LR = "R"
@export var Acceleration = 10
@export var MaxSpeed = 150.0
@export var JumpVel = 650.0
@export var SensorDir = "D"
@export var FallVel = 0
@export var Speed = 0
@export var Midair = 0
@export var midair = 0
@export var MachTurn = 0
var braking = 0
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
@export var Special = 0
#Mach 1 = 150
#Mach 2 = 300
#Mach 3 = 450
#Mach 4 = 600
#Mach 5 = 750

func _physics_process(delta):
	# Handle physics
	var Twurn = create_tween()
	if not is_on_floor() or not WallTouch == 0:
		if Midair <1:
			velocity.y= sin(rotation)*Speed
			Speed= cos(rotation)*Speed
		Midair += 1
		if Midair >4:
			set_up_direction(Vector2.UP)
			velocity.y += (gravity * delta)
			if velocity.y > 19000 and not is_on_floor():
				velocity.y = 19000
			if not round(rotation_degrees) == 0:
				Twurn.tween_property(self, "rotation", 0, 0.2)
			else:
				Twurn.stop()

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
	# Code for changing speed around
	var Dir = Input.get_axis("left", "right")
	if Dir and (((CtrlLock == "L" or WallTouch == -1) and Input.is_action_pressed("right")) or ((CtrlLock == "R" or WallTouch ==1) and Input.is_action_pressed("left")) or (CtrlLock == "N")) and not crouch == "S":
		if (not (Speed/(abs(Speed)*Dir)) == 1) and abs(Speed)> 50:
			braking = 1
			if dash == 0:
				Speed +=  Dir*Acceleration*2 * ((int(not WallTouch == 0)+1))
				CtrlLock = 0
			if dash == 1:
				if MachTurn == 0:
					PrevSpeed = Speed + (((int(LR=="R")*2)-1)*50)
					TurnSpeed = 1/(roundf(abs(Speed/120)))
					MachTurn = 1
				else:
					CtrlLock = "N"
					Speed = (lerpf(roundf(Speed), roundf(PrevSpeed*0.2), TurnSpeed))
				if abs(Speed) <= abs(PrevSpeed*0.2)+3:
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
		braking = 0
		if dash == 0:
			if abs(Speed) > 5:
				Speed -= Acceleration/1.5 * ((int(VelLR == "R")*2)-1)
			elif not Speed == 0:
				Speed = 0
				MachTurn = 0
				braking = 0
	else:
		braking = 0

	if is_on_floor() or (not WallTouch == 0) or Midair <=15:
		if Input.is_action_just_pressed("midair") and (is_on_floor() or (not WallTouch == 0) or Midair <= 15):
			$Jump.play()
			set_up_direction(Vector2.UP)
			if abs(WallTouch) == 1:
				Midair = 15
				Speed = ((int(VelLR == "L")*2)-1)*350
				velocity.y = -JumpVel
			else:
				velocity.y= sin(rotation)*Speed
				Speed = cos(rotation)*Speed
				Midair = 5
			Speed -= -JumpVel * sin(rotation)
			if WallTouch == 0:
				if not round(abs(rotation_degrees)) == 90:
					velocity.y += -JumpVel * cos(rotation) 
				else:
					velocity.y = -JumpVel*0.8 * ((int(LR == "L")*2)-1)
					SensorDir = "D"
	if Input.is_action_just_released("midair") and velocity.y < -200:
		velocity.y = -200
	if Input.is_action_just_pressed("midair") and Midair > 15 and Special == 0 and WallTouch == 0:
		if not abs(Speed) >= 500:
			Speed = Dir*500
		velocity.y = -175
		Special = 1
	elif Midair < 15:
		Special = 0

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

	#Wraps the angle and Slope Physics
	if WallTouch == 0 and is_on_floor_only():
		if ((Speed < 50 and SensorDir == "R" and LR == "R") or (Speed > -50 and SensorDir == "L" and LR == "L")):
			CtrlLock = SensorDir
		else:
			CtrlLock = "N"
		if not roundf(absf((rotation_degrees)/20)) == 0:
			if not CtrlLock == "N":
				braking = 1
				Speed +=sin(round(deg_to_rad(rotation_degrees)))*5
			elif SensorDir == "U" and dash == 1:
				Speed += sin(round(deg_to_rad(rotation_degrees)))*15
			if not SensorDir == "U" and dash ==1:
				Speed -= sin(round(deg_to_rad(-rotation_degrees)))*13
			else:
				Speed -= sin(round(deg_to_rad(-rotation_degrees)))*18
		var normal: Vector2 = get_floor_normal()
		if not deg_to_rad(round(rotation_degrees)) == (wrapf(rad_to_deg(normal.angle())+90, 180, -180)):
			rotation =  lerp_angle(rotation, deg_to_rad(wrapf(rad_to_deg(normal.angle())+90, 180, -180)), .5)
			
	else:
		CtrlLock = "N"


	#handles The surface direction, wallrunning, ceiling running all that good sonis stuff
	if (dash == 1 or is_on_floor() and WallTouch == 0):
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
		else:
			set_up_direction(Vector2.UP)
			velocity.y = 75
			Speed = 75 *((int(LR=="L")*2)-1)
	if dash == 0:
		floor_max_angle=67.5
		if round(abs(rotation_degrees)) > 67.5 or SensorDir == "U":
			if not SensorDir == "U":
				set_up_direction(Vector2.UP)
				velocity.x = 75 *((int(VelLR=="L")*2)-1)
				velocity.y = 10
				Speed = 50 *((int(VelLR=="L")*2)-1)
	else:
		floor_max_angle=180

	#Cam moverino
	$"Cam".offset.x=  $"Cam".offset.x*-1
	$"Cam".offset.y=  $"Cam".offset.y*-1
	$"Cam".offset.x-= ((5*($"Cam".offset.x))+((velocity.x)))/150
	$"Cam".offset.y-= (((5*($"Cam".offset.y))+((velocity.y)))/150)
	$"Cam".offset.x=  $"Cam".offset.x*-1
	$"Cam".offset.y=  $"Cam".offset.y*-1

func steppering():
	stepping = roundf(sin(Steps*(Speed*.001)) * 1)
	print(stepping)

func roundy1000thee(x):
	return (x *1000)/1

func _is_wall_touch(body):
	if body.name == "TileMap":
		WallTouch = ((int(LR == "L")*2)-1)
	else:
		WallTouch = 0
	print(WallTouch)


func _wall_not_touch(body):
	WallTouch = 0
