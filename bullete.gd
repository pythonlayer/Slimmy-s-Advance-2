extends Area2D

var speed = 750

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("Player"):
		body.get_damaged(1)
		
	queue_free()



func out():
	queue_free()
