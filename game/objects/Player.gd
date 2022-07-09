extends RigidBody2D

const MAX_SPEED : float = 200.0
const ACCEL : float = 20.0
const JUMP = -150

onready var body_anim : AnimatedSprite = $Body
onready var tread_anim : AnimatedSprite = $Treads
onready var coyote : Timer = $Coyote
onready var jump : Timer = $JumpMin
onready var jump_max : Timer = $JumpMax

# Collision stuff
onready var up : RayCast2D = $Up
onready var down : RayCast2D = $Down
onready var left : RayCast2D = $Left
onready var right : RayCast2D = $Right

export var flipped : bool = false
var flipped_coefficient : float = 1
var tread_speed : float = 1

enum State {
	Grounded
	Jumping
	Airborn
}

# so hack very why
enum AnimationState {
	NotJumping
	Jumping
}

var state = State.Grounded
var anim_state = AnimationState.NotJumping

func _ready():
	flipped_coefficient = int(flipped) * 2 - 1

func _process(delta):
	var direction = (Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")) * flipped_coefficient
	if(direction != 0) and anim_state == AnimationState.NotJumping:
		if direction > 0:
			body_anim.animation = "move_right" 
		elif direction < 0:
			body_anim.animation = "move_left"
		body_anim.playing = true
	else:
		body_anim.playing = false
	
	if Input.is_action_just_pressed("jump") and anim_state != AnimationState.Jumping:
		body_anim.animation = "jump"
		anim_state = AnimationState.Jumping
		body_anim.playing = true
	
	if anim_state == AnimationState.Jumping:
		if body_anim.frame == 3:
			body_anim.playing = false
	
	if abs(linear_velocity.x) > 0:
		tread_anim.speed_scale = max(abs(linear_velocity.x) / 50.0, 0.8)
		tread_anim.playing = true
	else:
		tread_anim.playing = false

func _physics_process(delta):
	if Input.is_action_pressed("jump"):
		jump.start()
		
	if(down.is_colliding() and state != State.Grounded and jump.is_stopped()):
		anim_state = AnimationState.NotJumping
		state = State.Grounded

func _integrate_forces(_state):
	var direction = (Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")) * flipped_coefficient
	linear_velocity.x += ACCEL * direction
	if Input.is_action_pressed("jump") and (jump_max.time_left > 0 || jump_max.is_stopped()) and state != State.Airborn:
		linear_velocity.y = JUMP
		state = State.Jumping
		if jump_max.is_stopped():
			jump_max.start()
	if state == State.Jumping and !Input.is_action_just_pressed("jump"):
		state = State.Airborn
	linear_velocity.x = clamp(linear_velocity.x, -MAX_SPEED, MAX_SPEED)
