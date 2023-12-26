extends Area2D

@onready var speed = 100

func _process(delta):
	$AnimatedSprite2D.play("patrol")
	position.x-=speed*delta



func _on_body_entered(body):
	print(body)
