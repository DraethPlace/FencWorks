extends GPUParticles2D

var type = "D"
var finish = 0

func _process(delta):
	if get_parent().get_parent().WallTouch ==0:
		one_shot = true
		if finish==1 or not get_parent().get_parent().Midair == 0:
			emitting = 0
		else:
			if speed_scale < 1:
				speed_scale =1
			else:
				speed_scale = 0.2/((abs(get_parent().get_parent().Speed))+0.1)
	else:
		if not abs((get_parent().get_parent().Speed)) >= 600:
			emitting = 1
			if one_shot == true:
				one_shot = 0
			finish = 0
			explosiveness =0.1
			amount =2
			process_material.scale_min = 1
			process_material.scale_max = 1
			if not abs(get_parent().get_parent().Speed)< 101:
				speed_scale = 1
	print(one_shot, finish)


func _on_finished():
	print("allalal")
	if one_shot == true:
		finish = 1
