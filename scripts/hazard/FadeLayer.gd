extends CanvasLayer

@onready var rect = $TextureRect

func fade_out():
	rect.visible = true
	rect.modulate.a = 0.0

	var t = create_tween()
	t.tween_property(rect, "modulate:a", 1.0, 0.3)
	await t.finished


func fade_in():
	rect.modulate.a = 1.0

	var t = create_tween()
	t.tween_property(rect, "modulate:a", 0.0, 0.3)
	await t.finished

	rect.visible = false
