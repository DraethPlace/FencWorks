extends Sprite2D

func _physics_process(_delta):
	if get_parent().LR == "L":
		flip_h = true
	else:
		flip_h = false
	scale.y = get_parent().get_node("HitBox").shape.height * .001
	scale.x = get_parent().get_node("HitBox").shape.radius * .003
