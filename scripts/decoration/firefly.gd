extends Node2D

@onready var sprite = $Sprite2D

var speed = 20.0
var direction = Vector2.ZERO

func _ready():
	randomize()

	# posisi jelas di layar (biar gak nyasar)
	position = Vector2(300, 200)

	# ukuran jangan kecil dulu
	scale = Vector2(1, 1)

	# WARNA FULL KELIHATAN (NO TRANSPARAN)
	sprite.modulate = Color(1, 1, 0.5, 1) # kuning terang

	change_direction()

	print("FIREFLY SPAWNED")


func _process(delta):
	position += direction * speed * delta


func change_direction():
	direction = Vector2(
		randf_range(-1, 1),
		randf_range(-1, 1)
	).normalized()

	await get_tree().create_timer(1.5).timeout
	change_direction()
