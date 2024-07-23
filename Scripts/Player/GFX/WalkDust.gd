extends GPUParticles2D

var type = "D"
var finish = 0

func _process(delta):
	if (abs(get_parent().get_parent().Speed) < 100 or not get_parent().get_parent().Midair == 0) or (abs((get_parent().get_parent().Speed)) >= 600 and not get_parent().get_parent().braking == 0):
		one_shot = true
		if finish==1 or not get_parent().get_parent().Midair == 0:
			emitting = 0
		else:
			if speed_scale < 1:
				speed_scale =1
			else:
				speed_scale = 0.35/((abs(get_parent().get_parent().Speed))+0.1)
	else:
		if not abs((get_parent().get_parent().Speed)) >= 600:
			emitting = 1
			if one_shot == true:
				one_shot = 0
			finish = 0
			texture = load("res://Images/Player/GFX/Dust1.png")
			explosiveness = abs(0.5/get_parent().get_parent().Speed)
			amount = 4
			process_material.angle_min= -get_parent().get_parent().rotation_degrees
			process_material.angle_max = -get_parent().get_parent().rotation_degrees
			process_material.scale_min = 1
			process_material.scale_max = 1
			process_material.gravity.x = sin(-get_parent().get_parent().rotation)*-65
			process_material.gravity.y = cos(-get_parent().get_parent().rotation)*-65
			if not abs(get_parent().get_parent().Speed)< 101:
				speed_scale = 1
	print(one_shot, finish)


func _on_finished():
	print("allalal")
	if one_shot == true:
		finish = 1
