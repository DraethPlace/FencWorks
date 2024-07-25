extends CanvasLayer
var g = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not g >50:
		offset.x +=25
		g+=1
