#extends Camera2D
#
#@export var smooth_speed := 0.1
#
#func _process(delta):
	## karena camera child Player, kita gak perlu cari player
	## kita cukup smoothing posisi lokal
#
	#global_position = global_position.lerp(get_parent().global_position, smooth_speed)
