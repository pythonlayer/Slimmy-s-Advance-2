extends Area2D

@export var speed = 20
@onready var move_dir =$"where to go".position
var start : Vector2
var end  : Vector2
var c = false
@onready var animator = $sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	start = global_position
	end = start + end


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if speed != 0:
		animator.flip_h = speed < 0
	if c == true:
		animator.play("attacking")
		global_position = global_position.move_toward(end,speed*delta)
		if global_position == end:
			if global_position == start:
				end = start + move_dir
			else:
				end = start
	else:
		animator.play("idle")
	if end.x-start.x > 0:
		animator.flip_h =true
	else:
		animator.flip_h =false






func is_in_range_close(body):
	c = true


func damage(body):
	end = global_position
	if body.is_in_group("Player"):
		body.get_damaged(0.25)

