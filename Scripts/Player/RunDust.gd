extends GPUParticles2D

var type = "D"

func _process(delta):
	if round(get_parent().get_parent().Speed/100) == 0 or not get_parent().get_parent().Midair == 0:
		emitting = 0
	else:
		emitting = 1
		if abs((get_parent().get_parent().Speed)) > 600:
			texture = load("res://Images/Player/GFX/Dust2.png")
			process_material.angular_velocity_min = 0
			process_material.angular_velocity_max = 0
			#explosiveness = abs(0.5/get_parent().get_parent().Speed)
			process_material.angle_min= -get_parent().get_parent().rotation_degrees
			process_material.angle_max = -get_parent().get_parent().rotation_degrees
		else:
			texture = load("res://Images/Player/GFX/Dust1.png")
			process_material.angular_velocity_min = 180
			process_material.angular_velocity_max = 180
			explosiveness = abs(0.5/get_parent().get_parent().Speed)
		process_material.direction.x = sin(rotation)
		process_material.direction.y = cos(rotation)
		amount = abs(round(get_parent().get_parent().Speed/100))
		process_material.gravity.x = sin(rotation)*15
		process_material.gravity.y = cos(rotation)*15
		process_material.scale_min = (abs(roundf(get_parent().get_parent().Speed/601)))+1
		process_material.scale_max = (abs(roundf(get_parent().get_parent().Speed/601)))+1
		process_material.emission_shape_offset.y = 168-(21 * abs(round(get_parent().get_parent().Speed/100)))
		print(explosiveness)
