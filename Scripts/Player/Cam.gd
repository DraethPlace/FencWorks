extends Camera2D
# Called when the node enters the scene tree for the first time.
func _physics_process(_delta):
	offset.x=  offset.x*-1
	offset.y=  offset.y*-1
	offset.x-= ((5*(offset.x))+((get_parent().velocity.x)))/150
	offset.y-= (((5*(offset.y))+((get_parent().velocity.y)))/150)
	offset.x=  offset.x*-1
	offset.y=  offset.y*-1
