extends Area2D






func _on_body_entered(body):
	$AnimationPlayer.play("spring")
	body.velocity.y = body.JUMP_VELOCITY * 2
	
