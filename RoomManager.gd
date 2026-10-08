extends Node

var cover = null
var RoomContainer = null

func _ready ():
	
	cover = get_node("/root/Main/Camera2D/ColorRect")
	cover.color.a = 0
	RoomContainer = get_node("/root/Main/RoomContainer")
	print("I am attached to: ", name)


func loadNextRoom() -> void:
	 # Fade to black
	var t1 = cover.create_tween()
	t1.tween_property(cover, "color:a", 1.0, 1.0)
	await t1.finished

	# Let physics finish before deleting old room
	await get_tree().process_frame

	# Delete old room
	for child in RoomContainer.get_children():
		child.queue_free()

	# Pick next room
	Globals.Roomnum = randi_range(1, Globals.TotalRooms)

	# Load new room
	var room = load("res://Scenes/Room%s.tscn" % Globals.Roomnum).instantiate()
	RoomContainer.add_child(room)

	# Let the room fully initialize
	await get_tree().process_frame
	await get_tree().physics_frame

	# Fade back in (ONE tween)
	var t2 = cover.create_tween()
	t2.tween_property(cover, "color:a", 0.0, 1.0)
	await t2.finished
