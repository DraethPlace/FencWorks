extends Area2D

func _process(delta):
	global_rotation = 0
	if not round(get_parent().rotation_degrees)/10 == 0:
		$Sens.disabled =true
		monitoring = false
		monitorable = false
		visible = false
	else:
		$Sens.disabled = false
		monitoring = true
		monitorable = true
		visible = true
