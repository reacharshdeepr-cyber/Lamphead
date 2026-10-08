extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var main = get_node("/root/Main")
	main.activate_tables()
