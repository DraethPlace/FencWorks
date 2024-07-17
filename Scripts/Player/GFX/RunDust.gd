extends GPUParticles2D

var type = "D"
var finish = 0

func _process(delta):
	if (round(get_parent().get_parent().Speed) == 0 or not get_parent().get_parent().Midair == 0) or (abs((get_parent().get_parent().Speed)) >= 600 and not get_parent().get_parent().braking == 0):
		one_shot = true
		if finish==1 or not get_parent().get_parent().Midair == 0:
			emitting = 0
	else:
		if not abs((get_parent().get_parent().Speed)) >= 600:
			emitting = 1
			if one_shot == true:
				one_shot = 0
			finish = 0
			texture = load("res://Images/Player/GFX/Dust1.png")
			explosiveness = abs(0.5/get_parent().get_parent().Speed)
			amount = 4
			process_material.scale_min = 1
			process_material.scale_max = 1
			process_material.angular_velocity_min = 180
			process_material.angular_velocity_max = 180
	print(one_shot, finish)


func _on_finished():
	print("allalal")
	if one_shot == true:
		finish = 1
