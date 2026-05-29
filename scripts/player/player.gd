extends CharacterBody2D

const SPEED = 220.0
const JUMP_FORCE = -420.0
const GRAVITY = 1200.0
const DASH_SPEED = 900.0
const DASH_TIME = 0.28
const DASH_DECEL = 0.15

var is_dashing = false
var dash_timer = 0.0
var dash_direction = Vector2.ZERO
var last_dir = 1
var dash_cooldown = 0.0

@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	# COOLDOWN
	if dash_cooldown > 0:
		dash_cooldown -= delta

	# GRAVITY
	if not is_on_floor() and not is_dashing:
		velocity.y += GRAVITY * delta

	# DASH PHASE
	if is_dashing:
		dash_timer -= delta
		var t = clamp(dash_timer / DASH_TIME, 0.0, 1.0)
		var speed = DASH_SPEED * (0.3 + 0.7 * t)
		velocity.x = dash_direction.x * speed
		velocity.y = lerp(velocity.y, 0.0, 0.3)
		if dash_timer <= 0:
			is_dashing = false
			velocity.x = dash_direction.x * SPEED * 1.4

	else:
		# MOVEMENT
		var dir = 0
		if Input.is_action_pressed("ui_right"):
			dir += 1
		if Input.is_action_pressed("ui_left"):
			dir -= 1

		var target_x: float = float(dir) * SPEED
		velocity.x = lerp(velocity.x, target_x, 0.18)

		if dir != 0:
			last_dir = dir

		# JUMP
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = JUMP_FORCE

		# DASH TRIGGER
		if Input.is_action_just_pressed("ui_accept") and dash_cooldown <= 0:
			start_dash(dir)

	move_and_slide()
	update_animation()


func start_dash(dir: int):
	var d = dir if dir != 0 else last_dir
	dash_direction = Vector2(float(d), 0.0)
	dash_timer = DASH_TIME
	dash_cooldown = 0.45
	is_dashing = true


func update_animation():
	if velocity.x != 0:
		anim.flip_h = velocity.x < 0

	if is_dashing:
		anim.play("dash")
	elif not is_on_floor():
		anim.play("jump")
	elif abs(velocity.x) > 10:
		anim.play("walk")
	else:
		anim.play("idle")
