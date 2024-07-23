extends Sprite2D

func _process(_delta):
	if get_parent().LR == "L":
		flip_h = true
	else:
		flip_h = false
	scale.y = get_parent().get_node("HitBox").shape.height/42
