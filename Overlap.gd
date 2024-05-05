extends Area2D


func _physics_process(delta):
	get_overlapping_bodies()
	if overlaps_body(get_node("TileMap")):
		body_entered.emit()
