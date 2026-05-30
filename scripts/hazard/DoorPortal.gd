extends Area2D

@export var next_scene : String

func _on_body_entered(body):
	if body.is_in_group("player"):
		await get_tree().root.get_node("Main/FadeLayer").fade_to_black()
		get_tree().change_scene_to_file(next_scene)
