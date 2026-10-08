extends CharacterBody2D

@export var speed = 30.0
@export var batteryLossPerSec = 5
@onready var Click1 = $ClickPlayer1
@onready var Click2 = $ClickPlayer2
@onready var hum = $HumPlayer
var humming: bool = false
func _physics_process(delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	# --- ANIMATION LOGIC ---
	if input_vector == Vector2.ZERO:
		$"Lamphead Animated".play("Idle")
	else:
		if input_vector.x == 0:
			$"Lamphead Animated".play("Walk FB")
		else:
			$"Lamphead Animated".play("Walk Right")
			if input_vector.x < 0:
				$"Lamphead Animated".flip_h = true
			elif input_vector.x > 0:
				$"Lamphead Animated".flip_h = false

	# --- MOVEMENT LOGIC ---
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

	velocity = (input_vector * speed).round()
	move_and_slide()

	position = position.round()
	
	if Globals.LampOn == true:
		Globals.set_battery(Globals.battery - (batteryLossPerSec * delta))
		
	if Globals.battery != 0 and Globals.LampOn == true and not humming:
			hum.play()
			humming = true
	elif Globals.battery == 0 or Globals.LampOn == false:
		if humming:
			hum.stop()
			humming = false
	
	if humming:
		hum.volume_db = Globals.battery / 5
		
func _input(event):
	if event.is_action_pressed("LightToggle") and Globals.battery > 0:
		if Globals.LampOn == true:
			Click1.play()
		else:
			Click2.play()
		Globals.LampOn = !Globals.LampOn
