extends CharacterBody2D

@export var speed = 300.0
var SPEED = speed 
@export var acceleration = 300.0
var ACCELERATION = acceleration
@export var jump_velocity = 400.0 
@export var friction = 300.0
var FRICTION = friction *16
var JUMP_VELOCITY = jump_velocity * -1 

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var GRAVITY = 1000
var gravity = GRAVITY
