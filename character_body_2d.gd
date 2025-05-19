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

var standing_cshape = preload("res://resources/standing_cshape.tres")
var crouching_cshape = preload("res://resources/crouching_cshape.tres")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * 1.5 * delta

	if Input.is_action_just_pressed("jump"):
		if is_on_floor() || can_coyote_jump:
			velocity.y = jump_force
			if can_coyote_jump:
				can_coyote_jump = false
		else:
			if !jump_buffered:
				jump_buffered = true
				jump_buffer_timer.start()

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
		
	if Input.is_action_just_pressed("crouch"):
		crouch()
	elif Input.is_action_just_released("crouch"):
		if clear_skies():
			stand()
		else:
			if stuck_under_object != true:
				stuck_under_object = true
	
	if stuck_under_object && clear_skies():
		stand()
		stuck_under_object = false

	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor && !is_on_floor() && velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start()
	
func _on_coyote_timer_timeout() -> void:
	can_coyote_jump = false
	
func _on_jump_buffer_timer_timeout() -> void:
	pass # Replace with function body.

func clear_skies() -> bool:
	var result = !crouchraycast_1.is_colliding() && !crouchraycast_2.is_colliding()
	return result
func crouch():
	if is_crouching:
		return
	is_crouching = true
	cshape.shape = crouching_cshape
	cshape.position.y = 26
func stand():
	if is_crouching == false:
		return
	is_crouching = false
	cshape.shape = standing_cshape
	cshape.position.y = 9.938
