extends Camera2D

@export var target: Node2D
@export var smooth_speed := 5.0
var shakeIntensity := 0.0

func _process(delta):
	if target:
		global_position = global_position.lerp(target.global_position, smooth_speed * delta)
	
	if shakeIntensity > 0:
		var random_offset = Vector2(
			randf_range(-shakeIntensity, shakeIntensity),
			randf_range(-shakeIntensity, shakeIntensity)
		)
		global_position += random_offset
		shakeIntensity = move_toward(shakeIntensity, 0, 0.2)

func _shake(intensity:float):
	shakeIntensity = intensity
