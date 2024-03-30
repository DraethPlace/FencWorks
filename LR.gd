extends Sprite2D

func _physics_process(_delta):
	var face = get_parent().LR
	if face == "L":
		flip_h = true
	else:
		flip_h = false
