extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_room_counter()
	call_deferred("_update_fraction_layout")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bar = get_tree().root.get_node("Main/Camera2D/CanvasLayer/Control/BatteryBar")
	bar.value = float(Globals.battery)
	_update_fraction_layout()
	
	if Globals.LampOn:
		bar.tint_progress = Color(1,1,1)
		$RoomCounter.modulate.a = Globals.battery / 1000 * 7
	else:
		bar.tint_progress = Color(0.727, 0.727, 0.727, 1.0)
		$RoomCounter.modulate.a = 0
	if Globals.lamp_stage == 100:
		bar.texture_progress = preload("res://Textures/Bar/Bar Fills (W)/100%.png")
		bar.texture_under = preload("res://Textures/Bar/Bar States/100%.png")
	elif Globals.lamp_stage == 80:
		bar.texture_progress = preload("res://Textures/Bar/Bar Fills (W)/80%.png")
		bar.texture_under = preload("res://Textures/Bar/Bar States/80%.png")
	elif Globals.lamp_stage == 60:
		bar.texture_progress = preload("res://Textures/Bar/Bar Fills (W)/60%.png")
		bar.texture_under = preload("res://Textures/Bar/Bar States/60%.png")
	elif Globals.lamp_stage == 40:
		bar.texture_progress = preload("res://Textures/Bar/Bar Fills (W)/40%.png")
		bar.texture_under = preload("res://Textures/Bar/Bar States/40%.png")
	elif Globals.lamp_stage == 20:
		bar.texture_progress = preload("res://Textures/Bar/Bar Fills (W)/20%.png")
		bar.texture_under = preload("res://Textures/Bar/Bar States/20%.png")
	elif Globals.lamp_stage == 0:
		bar.texture_under = preload("res://Textures/Bar/Bar States/0%.png")
		

func update_room_counter():
	$RoomCounter.text = str(Globals.RoomOn)
	
func _update_fraction_layout():
	var font: Font = $RoomCounter.get_theme_font("font")
	
	var num_size: Vector2 = font.get_string_size($RoomCounter.text)
	
