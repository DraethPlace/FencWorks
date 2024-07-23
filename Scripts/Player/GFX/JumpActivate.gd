extends CollisionShape2D
var Floortouch = 0
func _physics_process(delta):
	if (Input.is_action_pressed("midair") and get_parent().Midair < 15 or (int(Floortouch) == 0 and int(get_parent().is_on_floor())== 1)) and get_parent().WallTouch == 0:
		var jump_dust_scene = load("res://Scenes/Player/GFX/JumpDust.tscn")
		var jump_dust = jump_dust_scene.instantiate()
		add_child(jump_dust) 
	Floortouch = get_parent().is_on_floor()
