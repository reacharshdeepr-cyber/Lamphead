extends Control
@onready var clickPlayer = $Clicksound

func _on_play_pressed() -> void:
	clickPlayer.play()
	await clickPlayer.finished
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_quit_pressed() -> void:
	clickPlayer.play()
	await clickPlayer.finished
	get_tree().quit()
