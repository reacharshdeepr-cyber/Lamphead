extends Sprite2D

var player_in_range := false
@onready var indicator := $Label
func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		pickup()
	

func pickup():
	var sfx := $SFX
	sfx.play()
	print("Picked up:", name)
	if name == "screw":
		Globals.screwCollected()
	elif name == "battery":
		Globals.batteryCollected()
	elif name == ("key"):
		Globals.keyCollected()
	hide()
	player_in_range = false
	await sfx.finished
	queue_free()

func _on_area_entered(body):
	print("Entered:", name)
	if body.is_in_group("Player"):
		player_in_range = true
		show_outline(true)
		indicator.visible = true

func _on_area_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		show_outline(false)
		indicator.visible = false

func show_outline(state: bool):
	if state == true:
		material.set("shader_parameter/enabled", true)
	elif state == false:
		material.set("shader_parameter/enabled", false)
