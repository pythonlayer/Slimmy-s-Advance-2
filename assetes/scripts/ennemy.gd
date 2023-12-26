extends Area2D

@export var speed = 20
@onready var move_dir =$Marker2D.position
var start : Vector2
var end  : Vector2
var c = false
# Called when the node enters the scene tree for the first time.
func _ready():
	start = global_position
	end = start + end


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if speed != 0:
		$AnimatedSprite2D.flip_h = speed < 0
	if c == true:
		$AnimatedSprite2D.play("default")
		global_position = global_position.move_toward(end,speed*delta)
		if global_position == end:
			if global_position == start:
				end = start + move_dir
			else:
				end = start
	else:
		$AnimatedSprite2D.play("idle")
	if end.x-start.x > 0:
		$AnimatedSprite2D.flip_h =true
	else:
		$AnimatedSprite2D.flip_h =false






func close(body):
	c = true


func damage(body):
	end = global_position
	if body.is_in_group("Player"):
		body.get_damaged(0.25)
