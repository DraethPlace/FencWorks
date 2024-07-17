extends GPUParticles2D

var type = "D"
var finish = 0

func _process(delta):
	if (round(get_parent().get_parent().Speed) == 0 or not get_parent().get_parent().Midair == 0):
		one_shot = true
		if finish==1 or not get_parent().get_parent().Midair == 0:
			emitting = 0
	else:
		if one_shot == true:
			one_shot = 0
		finish = 0
		if abs((get_parent().get_parent().Speed)) > 600:
			texture = load("res://Images/Player/GFX/Dust2.png")
			process_material.angular_velocity_min = 0
			process_material.angular_velocity_max = 0
			explosiveness = abs(0.5/get_parent().get_parent().Speed)
			process_material.angle_min= -get_parent().get_parent().rotation_degrees
			process_material.angle_max = -get_parent().get_parent().rotation_degrees
			amount = 8
			material.particles_anim_h_frames=2
			material.particles_animation= 1
			material.particles_anim_h_frames=2
			process_material.scale_min = 1.5
			process_material.scale_max = 1.5
		else:
			texture = load("res://Images/Player/GFX/Dust1.png")
			explosiveness = abs(0.5/get_parent().get_parent().Speed)
			amount = 4
			material.particles_animation= 0
			material.particles_anim_h_frames=1
			material.particles_anim_h_frames=1
			process_material.scale_min = 1
			process_material.scale_max = 1
		process_material.direction.x = sin(rotation)
		process_material.direction.y = cos(rotation)
		process_material.gravity.x = sin(rotation)*-30
		process_material.gravity.y = cos(rotation)*-30
		process_material.velocity_pivot.x = sin(rotation)*-100
		process_material.velocity_pivot.y = cos(rotation)*-100
	print(one_shot, finish)
