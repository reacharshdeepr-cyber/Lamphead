extends Node2D

var active := false

func _ready() -> void:
	add_to_group("Tables")

func set_active(value: bool):
	active = value
	visible = value

	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = not value
			print("Table:", name, "| Toggled collision on", child.name, "->", not value)
		elif child.has_method("set_visible"):
			child.visible = value
			return
			
func spawn_item (itemType):
	
	var child = $Sprite2D
	for c in get_children():
		if c.is_in_group("Item"):
			if itemType != ("key"):
				print("BLOCKED SPAWN on", name, "because of leftover:", c.name)
				return
			else:
				clear_items()
	
	
	var sprite := Sprite2D.new()
	
	var indicator := Sprite2D.new()
	indicator.name = "Label"
	indicator.texture = load("res://Textures/Items/[E].png")
	indicator.visible = false
	sprite.add_child(indicator)
	indicator.position = Vector2(0,-10)
	
	sprite.set_script(load("res://Scripts/PickupLogic.gd"))
	sprite.name = itemType
	sprite.add_to_group("Item")
	sprite.texture = load("res://Textures/Items/%s.png" % itemType.capitalize())
	sprite.position = child.position  # local position relative to the table
	add_child(sprite)
	
	var sfx := AudioStreamPlayer2D.new()
	sfx.name = "SFX"
	sfx.stream = (load("res://pickup.ogg"))
	sprite.add_child(sfx)
	
	# --- PICKUP DETECTION AREA (SIBLING) ---
	var area := Area2D.new()
	area.add_to_group("Col")
	area.position = child.position
	area.collision_layer = 0
	area.collision_mask = 1
	add_child(area)
	# --- COLLISION SHAPE (ALSO A SIBLING) ---
	var shape := CollisionShape2D.new()
	shape.add_to_group("Col")
	shape.shape = CircleShape2D.new()
	shape.shape.radius = 20
	shape.position = area.position
	shape.disabled = false
	shape.one_way_collision = false
	shape.set_deferred("disabled", false)
	area.add_child(shape)
	
	
	
	
	var shader := load("res://Shaders/Outline.gdshader")
	var mat := ShaderMaterial.new()
	mat.shader = shader
	sprite.material = mat

	# Connect signals to the PickupLogic script on the sprite
	area.body_entered.connect(sprite._on_area_entered)
	area.body_exited.connect(sprite._on_area_exited)
	
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		var bodies = area.get_overlapping_bodies()
		if bodies.has(player):
			sprite._on_area_entered(player)


func clear_items():
	for child in get_children():
		if child.is_in_group("Item") or child.is_in_group("Col"):
			child.queue_free()
		if not child.is_in_group("Item"):
			continue
