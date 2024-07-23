extends Label


func _process(delta):
	text = "Speed:"+str(get_parent().get_parent().get_parent().Speed)
