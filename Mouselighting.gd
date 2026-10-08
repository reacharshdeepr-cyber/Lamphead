extends PointLight2D


# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
