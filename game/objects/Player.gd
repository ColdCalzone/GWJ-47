extends RigidBody2D

const MAX_SPEED : float = 100.0
const ACCEL : float = 700.0
const JUMP_IMPUSE : float = -250.0
const JUMP_DEACCEL : float = 2.5
const FRICTION : float = -360.0

# Animation
onready var body_anim : AnimatedSprite = $Body
onready var tread_anim : AnimatedSprite = $Treads

# Timers for that nice jumping
onready var jump : Timer = $JumpMin
onready var jump_max : Timer = $JumpMax

var coyote : float = 0.25
const COYOTE_MAX : float = 0.25

# Floor stuff
onready var down : RayCast2D = $Down
onready var up : RayCast2D = $Up

export var flipped : bool = false
var flipped_coefficient : float = 1
var tread_speed : float = 1

# States the player enters
# Not doing a proper Finite State Machine, but that may be something I need to change.
enum State {
	Grounded
	Jumping
	Airborn
}

var state = State.Grounded

func _ready():
	flipped_coefficient = int(flipped) * 2 - 1

# Animation stuff is handled here
func _process(_delta):
	# right = 1 left = -1
	var direction = (Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")) * flipped_coefficient
	if(direction != 0) and state == State.Grounded:
		if direction > 0:
			body_anim.animation = "move_right" 
		elif direction < 0:
			body_anim.animation = "move_left"
		body_anim.playing = true
		if body_anim.speed_scale != 1:
			body_anim.speed_scale = 1
	elif state == State.Grounded:
		body_anim.playing = false
		if body_anim.animation == "jump_right":
			body_anim.animation = "move_right"
		elif body_anim.animation == "jump_left":
			body_anim.animation = "move_left"
	
	if state == State.Jumping and body_anim.animation != "jump_right" and body_anim.animation != "jump_left":
		if body_anim.animation == "move_right":
			body_anim.animation = "jump_right"
		elif body_anim.animation == "jump_left":
			body_anim.animation = "jump_left"
		body_anim.speed_scale = 3
		body_anim.playing = true
	
	if state == State.Jumping || state == State.Airborn:
		if !Input.is_action_pressed("jump") or jump_max.is_stopped():
			body_anim.playing = true
		elif body_anim.frame == 1:
			body_anim.playing = false
		if body_anim.frame == 3:
			if body_anim.animation == "jump_right":
				body_anim.animation = "move_right"
			else:
				body_anim.animation = "move_left"
			body_anim.speed_scale = 1
			body_anim.playing = false
	
	if abs(linear_velocity.x) > 0:
		# Dynamic tread speed :)
		tread_anim.speed_scale = max(abs(linear_velocity.x) / 50.0, 0.8)
		tread_anim.playing = true
	else:
		tread_anim.playing = false

func _physics_process(delta):
	if up.is_colliding() and state == State.Jumping:
		state = State.Airborn
	if Input.is_action_just_pressed("jump") and state != State.Airborn:
		state = State.Jumping
		jump.start()
		jump_max.start()
	# if we're jumping, and you've either stopped pressing jump or the maximum jump length is done, and the minimum jump length is done...
	elif state == State.Jumping and (!Input.is_action_pressed("jump") || jump_max.is_stopped()) and jump.is_stopped():
		state = State.Airborn
		jump_max.stop()
	if(down.is_colliding() and state != State.Grounded and jump.is_stopped()):
		state = State.Grounded
	elif !down.is_colliding() and state == State.Grounded and coyote > 0:
		coyote -= delta
	elif down.is_colliding() and state == State.Airborn:
		state = State.Grounded
	if down.is_colliding() and coyote < COYOTE_MAX:
		coyote = COYOTE_MAX
	if coyote <= 0:
		state = State.Airborn

func _integrate_forces(_state):
	var step = _state.get_step()
	var direction = (Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")) * flipped_coefficient
	linear_velocity.x += (ACCEL * direction) * step
	var vx = abs(linear_velocity.x)
	vx += FRICTION * step
	if vx < 0: vx = 0
	linear_velocity.x = vx * sign(linear_velocity.x)
	if state == State.Jumping:
		if linear_velocity.y >= 0: linear_velocity.y = JUMP_IMPUSE
		linear_velocity.y += JUMP_DEACCEL * step
	if state == State.Airborn:
		linear_velocity.y = max(linear_velocity.y, JUMP_IMPUSE / 2)
	linear_velocity.x = clamp(linear_velocity.x, -MAX_SPEED, MAX_SPEED)
