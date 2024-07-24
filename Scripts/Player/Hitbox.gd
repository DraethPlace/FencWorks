extends CollisionShape2D

func _process(delta):
	if get_parent().crouch == "N":
		if not shape.height >= 42:
			shape.height += 7
		else:
			shape.height = 42
	else:
		if not shape.height <= 21:
			shape.height -= 7
		else:
			shape.height = 21
