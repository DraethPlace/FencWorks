extends CollisionShape2D
var Floortouch = 0
func _physics_process(delta):
	if (Input.is_action_just_pressed("midair") and get_parent().Midair < 15 or (int(Floortouch) == 0 and int(get_parent().is_on_floor())== 1)):
		if not get_parent().WallTouch == 0:
			if get_parent().LR == "R":
				var wallr_scene = load("res://Scenes/Player/GFX/WallJumpDustR.tscn")
				var wallr = wallr_scene.instantiate()
				add_child(wallr) 
			elif get_parent().LR == "L":
				var walll_scene = load("res://Scenes/Player/GFX/WallJumpDustL.tscn")
				var walll = walll_scene.instantiate()
				add_child(walll) 
		else:
			var jump_dust_scene = load("res://Scenes/Player/GFX/JumpDust.tscn")
			var jump_dust = jump_dust_scene.instantiate()
			add_child(jump_dust) 
	Floortouch = get_parent().is_on_floor()
