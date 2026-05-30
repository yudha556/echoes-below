var flower_scene = preload("res://assets/assetScene/flowers.tscn")

func _ready():
	var f = flower_scene.instantiate()
	f.position = Vector2(300, 200)
	add_child(f)
