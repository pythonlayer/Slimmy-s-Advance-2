extends Area2D


# Called when the node enters the scene tree for the first time.
signal super_jump 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bodies = get_overlapping_bodies()
	$AnimationPlayer.play('idle')
	for body in bodies:
		if body.name == "Player1" or body.name == "Player2":
			$AnimationPlayer.play('spring')
			emit_signal("super_jump")
		
