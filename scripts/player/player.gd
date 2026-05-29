extends CharacterBody2D

# === MOVEMENT ===
const SPEED          = 1220.0   # naik dari 320
const ACCEL          = 3500.0  # lebih responsif
const DECEL          = 4000.0
const AIR_ACCEL      = 2400.0
const AIR_DECEL      = 1200.0

# === JUMP ===
const JUMP_FORCE     = -1320.0  # naik dari -620
const GRAVITY_UP     = 1800.0
const GRAVITY_DOWN   = 2800.0  # lebih berat = feel nendang
const JUMP_CUT       = 0.4
const COYOTE_TIME    = 0.1
const JUMP_BUFFER    = 0.1

# === DASH ===
const DASH_SPEED     = 3800.0  # naik dari 1100
const DASH_TIME      = 0.125
const DASH_COOLDOWN  = 0.05

var is_dashing       = false
var dash_timer       = 0.0
var dash_used        = false    # 1x dash per udara, isi saat landing
var dash_cooldown    = 0.0
var dash_direction   = Vector2.ZERO

var coyote_timer     = 0.0
var jump_buffer      = 0.0
var was_on_floor     = false
var is_jump_cut      = false

@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	var on_floor = is_on_floor()

	# isi ulang dash saat landing
	if on_floor and not was_on_floor:
		dash_used = false

	# coyote time
	if was_on_floor and not on_floor and not is_dashing:
		coyote_timer = COYOTE_TIME
	if coyote_timer > 0:
		coyote_timer -= delta

	# jump buffer
	if Input.is_action_just_pressed("ui_up"):
		jump_buffer = JUMP_BUFFER
	if jump_buffer > 0:
		jump_buffer -= delta

	# dash cooldown
	if dash_cooldown > 0:
		dash_cooldown -= delta

	# ======================
	# GRAVITY (asymmetric)
	# ======================
	if not on_floor and not is_dashing:
		if velocity.y < 0:
			velocity.y += GRAVITY_UP * delta
		else:
			velocity.y += GRAVITY_DOWN * delta

	# ======================
	# DASH
	# ======================
	if is_dashing:
		dash_timer -= delta
		velocity.x = dash_direction.x * DASH_SPEED
		velocity.y = 0.0
		if dash_timer <= 0:
			is_dashing = false
			dash_cooldown = DASH_COOLDOWN
			# sisa momentum setelah dash
			velocity.x = dash_direction.x * SPEED * 0.8
	else:
		# ======================
		# HORIZONTAL MOVEMENT
		# ======================
		var dir = 0
		if Input.is_action_pressed("ui_right"):
			dir += 1
		if Input.is_action_pressed("ui_left"):
			dir -= 1

		var accel = ACCEL if on_floor else AIR_ACCEL
		var decel = DECEL if on_floor else AIR_DECEL

		if dir != 0:
			var target_x = float(dir) * SPEED
			velocity.x = move_toward(velocity.x, target_x, accel * delta)
		else:
			velocity.x = move_toward(velocity.x, 0.0, decel * delta)

		# ======================
		# JUMP
		# ======================
		var can_jump = on_floor or coyote_timer > 0
		if jump_buffer > 0 and can_jump:
			velocity.y = JUMP_FORCE
			jump_buffer = 0.0
			coyote_timer = 0.0
			is_jump_cut = false

		# variable jump height: lepas tombol = potong naik
		if Input.is_action_just_released("ui_up") and velocity.y < 0:
			velocity.y *= JUMP_CUT

		# ======================
		# DASH TRIGGER
		# ======================
		if Input.is_action_just_pressed("ui_accept") and not dash_used and dash_cooldown <= 0:
			start_dash(dir)

	move_and_slide()
	was_on_floor = is_on_floor()
	update_animation()


func start_dash(dir: int):
	if dir == 0:
		dir = -1 if anim.flip_h else 1
	is_dashing = true
	dash_used = true
	dash_timer = DASH_TIME
	dash_direction = Vector2(float(dir), 0.0)


func update_animation():
	if not is_dashing and velocity.x != 0:
		anim.flip_h = velocity.x < 0

	if is_dashing:
		anim.play("dash")
	elif not is_on_floor():
		if velocity.y < 0:
			anim.play("jump")
		else:
			# ganti ke "fall" kalau punya animasinya, kalau engga pakai jump
			anim.play("jump")
	elif abs(velocity.x) > 10:
		anim.play("walk")
	else:
		anim.play("idle")
