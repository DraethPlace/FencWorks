extends GPUParticles2D

var type = "D"
var finish = 0

func _process(delta):
	process_material.direction.x = cos(rotation)*1
	process_material.direction.y = cos(rotation)*-3
	emitting = 1
	one_shot=1
	if finish==1:
		emitting = 0


func _on_finished():

	if one_shot == true:
		finish = 1
