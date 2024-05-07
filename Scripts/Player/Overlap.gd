extends Area2D


func _physics_process(delta):
	if overlaps_body(get_node("TileMap")):
		body_entered.emit()
