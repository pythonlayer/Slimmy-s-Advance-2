extends CharacterBody2D

# Constants for movement
@export var speed = 300.0
var SPEED = speed 
@export var acceleration = 300.0
var ACCELERATION = acceleration
@export var friction = 300.0
var FRICTION = friction * 16

# Gravity and jump settings
@export var jump_peack = 0.5
@export var jump_height = 75.0
@export var air_acceleration = 300
@export var air_friction = 18.0
@export var air_jump = true

# Player and animator references
@onready var player_1 = "."
@onready var animator = $animator
@onready var coyote_jump_timer = $CoyoteJump
@onready var run = $run
@onready var jump = $jump
@onready var gravity = (2 * jump_height) / pow(jump_peack, 2)
@onready var JUMP_VELOCITY = gravity * jump_peack * -1
@onready var health = 5
@onready var label = $Life
@onready var death = $Death
@onready var puchy = false

# Time window for coyote jump
var COYOTE_TIME_WINDOW = 0.1 # Adjust as needed (in seconds)

# Update physics
func _physics_process(delta):
	apply_gravity(delta)
	handle_jump(delta)
	handle_movement(delta)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start(COYOTE_TIME_WINDOW) # Start coyote jump timer

# Update animations
func _process(delta):
	update_sprite()
	update_animation()

# Apply gravity to velocity
func apply_gravity(delta):
	if not is_on_floor():
		jump.set_emitting(true)
		velocity.y += gravity * delta
	else:
		jump.set_emitting(false)

# Handle jumping logic
func handle_jump(delta):
	if is_on_floor():
		air_jump = true
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("JumpP1"):
			velocity.y = JUMP_VELOCITY
	elif not is_on_floor():
		pass

# Handle player movement
func handle_movement(delta):
	var direction = Input.get_axis("leftP1", "rightP1")
	if is_on_floor():
		if direction != 0:
			velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION * delta)
			run.set_amount(SPEED / 8)
			run.set_emitting(true)
		else:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			run.set_emitting(false)
	else:
		run.set_emitting(false)
		if direction != 0:
			velocity.x = move_toward(velocity.x, SPEED * direction, air_acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, air_friction * delta)

# Update sprite direction
func update_sprite():
	var right = Input.is_action_pressed("rightP1")
	var left = Input.is_action_pressed("leftP1")
	if right:
		puchy = false
		$Playersprite.flip_h = false
	if left:
		puchy = false
		$Playersprite.flip_h = true

# Update animation based on player state
func update_animation():
	var right = Input.is_action_pressed("rightP1")
	var left = Input.is_action_pressed("leftP1")
	if puchy == false:
		if velocity.y > -10 and not is_on_floor():
			animator.play("fall")
		elif velocity.y < 3 and not is_on_floor():
			animator.play("jump")
		elif right or left:
			animator.play("run")
		else:
			animator.play("idle")

# Restart scene on collision
func _on_dead_zones_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	restart_scene()

# Restart scene function
func restart_scene():
	health -= 1
	if health > 0:
		var text_to_show = "X" + str(health)
		label.set_text(text_to_show)
		player_1.set_position(Vector2(0,0))
		player_1.visible = false
		death.start()
		player_1.visible = true
	else:
		player_1.queue_free()

# Handle collisions with other entities
func collide_right(body):
	if body.is_in_group("Player") and body != $".": 
		puchy = true
		if abs(body.velocity.x) > abs(velocity.x):
			$Playersprite.flip_h = true
			animator.stop()
		$RIGHT/colition.debug_color = Color(0.90, 0.6, 0.0, 0.41)
		if velocity.x == 0:
			velocity.x = body.velocity.x + body.SPEED
		animator.play("puched")

func collide_left(body):
	if body.is_in_group("Player") and body != $".": 
		puchy = true
		if abs(body.velocity.x) > abs(velocity.x):
			$Playersprite.flip_h = false
			animator.stop()
		$LEFT/colition.debug_color = Color(0.90, 0.6, 0.0, 0.41)
		if velocity.x == 0:
			velocity.x = body.velocity.x + body.SPEED
		animator.play("puched")

func _on_right_body_exited(body):
	puchy = false
	$RIGHT/colition.debug_color = Color(0.0, 0.6, 0.7, 0.41)

func _on_left_body_exited(body):
	puchy = false
	$LEFT/colition.debug_color = Color(0.0, 0.6, 0.7, 0.41)

func get_damaged(amount):
	puchy = true
	$animator.stop()
	$animator.play("damage")
	$Dammage.emitting = true
	health -= amount
	if health < 0:
		health = 0
	var text_to_show = "X" + str(health)
	label.set_text(text_to_show)
	await get_tree().create_timer(1).timeout
	$Dammage.emitting = false

func STOMP(body):
	if body.is_in_group("Player") and body != $".": 
		puchy = true
		velocity = -velocity / 2
		animator.stop()
		animator.play("stomped on")

func BUMP(body):
	coyote_jump_timer.start()
	if body.is_in_group("Player") and body != $".": 
		velocity.y = -velocity.y 
