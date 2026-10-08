extends AnimatedSprite2D

var playerInRange:bool = false
var indicator := Sprite2D.new()
var Player = null

func _ready() -> void:
	Player = get_node("/root/Main/CharacterBody2D")
	indicator.name = "Label"
	indicator.texture = load("res://Textures/Items/[E].png")
	indicator.visible = false
	add_child(indicator)
	indicator.position = Vector2(0,-10)

func _process(delta: float) -> void:
	if playerInRange and Input.is_action_just_pressed("interact") and not Globals.loadingNextRoom:
		if Globals.key_room:
			play("Locked")
			await get_tree().create_timer(1.0).timeout 
			stop()
		else:
			var Main = get_node("/root/Main")
			Main.loadNextRoom()

	
func show_outline(state: bool):
	if state == true:
		material.set("shader_parameter/enabled", true)
	elif state == false:
		material.set("shader_parameter/enabled", false)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		playerInRange = true
		show_outline(true)
		indicator.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		playerInRange = false
		show_outline(false)
		indicator.visible = false
