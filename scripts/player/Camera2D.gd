extends Camera2D

@export var tilemap: TileMap

func _ready():
	if tilemap == null:
		return

	var used_rect = tilemap.get_used_rect()
	var tile_size = tilemap.tile_set.tile_size

	# posisi world dalam pixel
	var world_pos = used_rect.position * tile_size
	var world_size = used_rect.size * tile_size

	limit_left = world_pos.x
	limit_top = world_pos.y
	limit_right = world_pos.x + world_size.x
	limit_bottom = world_pos.y + world_size.y
