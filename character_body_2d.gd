extends CharacterBody2D

@export var walk_speed = 400.0
@export var run_speed = 600.0
@export_range(0, 1) var acceleration = 0.1
@export_range(0, 1) var deceleration = 0.1
@export var jump_force = -800.0
@export_range(0, 1) var decelerate_on_jump_release = 0.5

var is_crouching = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * 1.5 * delta

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_force

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
		stand()


	move_and_slide()


func crouch():
	if is_crouching:
		return
	is_crouching = true
func stand():
	if is_crouching == false:
		return
	is_crouching = false
