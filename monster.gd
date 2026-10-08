extends CharacterBody2D

var player = null
var speed = 30
var animator = null
var retreat:bool = false
var direction = null
var hitActive:bool = true
var hitbox = null
var spawntime = 3
var collider = null
var camera = null

func _ready():
	player = get_node("/root/Main/CharacterBody2D")
	animator = $AnimatedSprite2D
	hitbox = $Hitbox
	collider = $CollisionShape2D
	camera = get_node("/root/Main/Camera2D")
	
func _physics_process(delta):
# Movement Towards Player
	if player != null:
		direction = (player.global_position - global_position).normalized()
		if retreat == false:
			velocity = direction * speed
		else:
			velocity = direction * (speed * -3)
		move_and_slide()

# State Manager
	if Globals.monsterAggro == false:
		speed = 25
		animator.play("Walk")
	else:
		speed = 70
		animator.play("Run")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and hitActive == true:
		Globals.set_lamp_health(Globals.lamp_health - 20)
		print("HIT")
		if Globals.LampOn == true:
			Globals._flicker()
		camera._shake(5)
		retreat = true
		hitActive = false
		await get_tree().create_timer(2.0).timeout
		retreat = false
		hitActive = true
		
		if hitbox.overlaps_body(body):
			_on_hitbox_body_entered(body)

func spawn():
	spawntime = randf_range(2.0, 4.0)
	await get_tree().create_timer(spawntime).timeout
	if Globals.LampOn == true:
		Globals._flicker()
	global_position = Vector2.ZERO
	set_physics_process(true)
	show() # Makes the sprite visible
	hitActive = true
	retreat = false
	collider.set_deferred("disabled", false)

func despawn():
	set_physics_process(false)
	hide() # Hides the sprite
	hitActive = false
	collider.set_deferred("disabled", true)
