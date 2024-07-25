extends GPUParticles2D

var type = "D"
var finish = 0

func _process(delta):
	if (abs(get_parent().get_parent().Speed) < 100 or not get_parent().get_parent().Midair == 0) or (not abs((get_parent().get_parent().Speed)) >= 600 and not get_parent().get_parent().braking == 0):
		one_shot = true
		process_material.angle_min= -get_parent().get_parent().rotation_degrees
		process_material.angle_max = -get_parent().get_parent().rotation_degrees
		if finish==1 or not get_parent().get_parent().Midair == 0:
			emitting = 0
	else:
		if abs((get_parent().get_parent().Speed)) >= 600:
			emitting = 1
			if one_shot == true:
				one_shot = 0
			finish = 0
			texture = load("res://Images/Player/GFX/Dust2.png")
			process_material.angular_velocity_min = 0
			process_material.angular_velocity_max = 0
			explosiveness = abs(0.5/get_parent().get_parent().Speed)
			process_material.angle_min= -get_parent().get_parent().rotation_degrees
			process_material.angle_max = -get_parent().get_parent().rotation_degrees
			amount = 8
			material.particles_anim_h_frames=2
			material.particles_animation= true
			material.particles_anim_h_frames=2
			process_material.scale_min = 1.75
			process_material.scale_max = 1.75
			process_material.angular_velocity_min = 0
			process_material.angular_velocity_max = 0
			if not abs(get_parent().get_parent().Speed)< 101:
				speed_scale = 1
	process_material.angle_min= -get_parent().get_parent().rotation_degrees
	process_material.angle_max = -get_parent().get_parent().rotation_degrees


func _on_finished():
	if one_shot == true:
		finish = 1
