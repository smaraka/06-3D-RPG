extends RayCast


func _physics_process(_delta):
	if is_colliding():
		var pos = get_collision_point()
		$Reticle.global_transform.origin = pos
	elif $Reticle.translation != Vector3(0,0,50):
		$Reticle.translation = Vector3(0,0,50)
