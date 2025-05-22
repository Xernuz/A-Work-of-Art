extends CharacterBody2D

@export var walk_speed = 400.0
@export var run_speed = 600.0
@export_range(0, 1) var acceleration = 0.1
@export_range(0, 1) var deceleration = 0.1
@export var jump_force = -800.0
@export_range(0, 1) var decelerate_on_jump_release = 0.5
@onready var cshape = $CollisionShape2D
@onready var crouchraycast_1 = $RayCast2D_1
@onready var crouchraycast_2 = $RayCast2D_2
@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer_timer = $JumpBufferTimer

var is_crouching = false
var stuck_under_object = false
var can_coyote_jump = false
var jump_buffered = false
var crouch_intent = false  # Tracks actual crouch button state

var standing_cshape = preload("res://resources/standing_cshape.tres")
var crouching_cshape = preload("res://resources/crouching_cshape.tres")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * 1.5 * delta

	if Input.is_action_just_pressed("jump"):
		jump()

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decelerate_on_jump_release

	var speed
	if Input.is_action_pressed("run"):
		speed = run_speed
	else:
		speed = walk_speed
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)

	# Track the crouch intent
	crouch_intent = Input.is_action_pressed("crouch")

	# Update stuck state
	stuck_under_object = not clear_skies()

	# Handle crouching
	if crouch_intent or stuck_under_object:
		jump_force = -600
		crouch()
	else:
		jump_force = -800
		if not stuck_under_object:
			stand()

	var was_on_floor = is_on_floor()
	move_and_slide()

	if was_on_floor and not is_on_floor() and velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start()

	if not was_on_floor and is_on_floor():
		if jump_buffered:
			jump_buffered = false
			jump()

func jump():
	if is_on_floor() or can_coyote_jump:
		velocity.y = jump_force
		if can_coyote_jump:
			can_coyote_jump = false
	else:
		if not jump_buffered:
			jump_buffered = true
			jump_buffer_timer.start()

func _on_coyote_timer_timeout() -> void:
	can_coyote_jump = false

func _on_jump_buffer_timer_timeout() -> void:
	jump_buffered = false

func clear_skies() -> bool:
	return not crouchraycast_1.is_colliding() and not crouchraycast_2.is_colliding()

func crouch():
	if is_crouching:
		return
	is_crouching = true
	cshape.shape = crouching_cshape
	cshape.position.y = 26

func stand():
	if not is_crouching:
		return
	is_crouching = false
	cshape.shape = standing_cshape
	cshape.position.y = 9.938
