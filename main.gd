extends Node2D
var cover = null
var RoomContainer = null
var Player = null
var count_to_activate = 0
var UI = null
var monster = null

func _ready():
	UI = get_node("/root/Main/Camera2D/CanvasLayer/Control") 
	Player = get_node("/root/Main/CharacterBody2D")
	cover = get_node("/root/Main/Camera2D/ColorRect")
	cover.color.a = 0
	RoomContainer = get_node("/root/Main/RoomContainer")
	monster = $Monster
	activate_tables()

func _input(event):
	if Globals.dev_mode and event.is_action_pressed("reroll_tables"):
		activate_tables()

func activate_tables():
	
	var tables = get_tree().get_nodes_in_group("Tables")
	tables.shuffle()  # Randomize order

# Manager of number of tables spawned per room
	if Globals.Roomnum in range(1, 8 + 1):
		count_to_activate = 5
	
	var active_tables = []

	# Activate the first 4 tables after shuffle
	for i in range(tables.size()):
		var table = tables[i]
		var is_active = i < count_to_activate

		table.set_active(is_active)

		if is_active:
			active_tables.append(table)
			table.clear_items()

	# Decide if this is a key room
	Globals.key_room = randi_range(0, 1)
	var key_table = null
	print ("Key room", Globals.key_room)

	if Globals.key_room == 1:
		key_table = active_tables.pick_random()
		key_table.clear_items()   # ← FIX
		print("KEY TABLE:", key_table.name)
		key_table.spawn_item("key")

	for table in active_tables:
		var extra_items = []

		if table == key_table:
			print("Skipping extras on key table:", table.name)
			continue

		if randf() < Globals.batteryChance:
			extra_items.append("battery")

		if randf() < Globals.screwChance:
			extra_items.append("screw")

		if extra_items.size() > 0:
			var chosen = extra_items.pick_random()
			print("Spawning", chosen, "on", table.name)
			table.spawn_item(chosen)
			
		print("Active tables:", active_tables)
		
func loadNextRoom() -> void:
	Globals.loadingNextRoom = true
	monster.despawn()
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
	Globals.RoomOn +=1
	
	Globals.batteryChance = 0.25 + Globals.RoomOn / 200.0
	Globals.screwChance   = 0.25 - Globals.RoomOn / 200.0
	
	@warning_ignore("integer_division")
	Globals.batteryChance = 0.25 + Globals.RoomOn / 1 / 100
	@warning_ignore("integer_division")
	Globals.screwChance = 0.25 - Globals.RoomOn / 1 / 100
	
	Globals.batteryChance = clamp(Globals.batteryChance, 0.0, 0.5)
	Globals.screwChance   = clamp(Globals.screwChance, 0.0, 0.5)

	var room = load("res://Scenes/Room%s.tscn" % Globals.Roomnum).instantiate()
	RoomContainer.add_child(room)
	
	UI.update_room_counter()
	
	# Let the room fully initialize
	await get_tree().physics_frame
	activate_tables()
	Player.position = Vector2(0, 0)
	monster.spawn()
	await get_tree().create_timer(0.3).timeout
	
	var t2 = cover.create_tween()
	t2.tween_property(cover, "color:a", 0.0, 1.0)
	await t2.finished
	
	Globals.loadingNextRoom = false
	
func die() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game Over.tscn")
	
func _process(delta: float) -> void:
	if Globals.lamp_health == 0:
		die()
