extends Sprite2D

var t := 0.0

func _process(delta):
	t += delta

	scale = Vector2(1.0, 1.0) + Vector2(0.04, 0.04) * sin(t * 2.0)

	position.x = sin(t * 1.5) * 1.0
	position.y = cos(t * 1.2) * 0.5

	modulate.a = 0.22 + sin(t * 3.0) * 0.015
