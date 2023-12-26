extends Label

var speed = 5
var amplitude = 10
var offset = 0

func _process(delta):
	offset += delta * speed
	var y = amplitude * sin(offset)
	set_position(Vector2(position.x, y))
