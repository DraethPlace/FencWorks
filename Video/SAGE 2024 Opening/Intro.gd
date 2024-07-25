extends VideoStreamPlayer

var simultaneous_scene = preload("res://Scenes/Base Level.tscn").instantiate()


func _on_finished():
	get_tree().root.add_child(simultaneous_scene)
