extends Camera2D

@onready var move_speed = 0.5  # camera position lerp speed
@onready var zoom_speed = 0.25  # camera zoom lerp speed
@onready var min_zoom = 1 # camera won't zoom closer than this
@onready var max_zoom = 0.5  # camera won't zoom farther than this
@onready var margin = Vector2(0, 0)  # include some buffer area around targets

var targets = []
 # Array of targets to be tracked.

@onready var screen_size = get_viewport_rect().size

func _ready():
	targets.append($"../Player1")
	targets.append($"../Player2")

func _process(delta):
	if !targets:
		return
	# Keep the camera centered between the targets
	var p = Vector2.ZERO
	for target in targets:
		if is_instance_valid(target) :
			p += target.position
	p /= targets.size()
	position = lerp(position, p, move_speed)
	# Find the zoom that will contain all targets
	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		if is_instance_valid(target)  :
			r = r.expand(target.position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	var d = max(r.size.x, r.size.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = clamp(r.size.x / screen_size.x, min_zoom, max_zoom)
	else:
		z = clamp(r.size.y / screen_size.y, min_zoom, max_zoom)
	zoom = lerp(zoom, Vector2.ONE * z, zoom_speed)
