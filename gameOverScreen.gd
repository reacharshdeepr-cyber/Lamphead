extends Control

var roomCounter = null
var text = null
var chosenText = null

var death_messages: Array[String] = [
	"The light went out.",
	"Where does death of the body stand in front of death of the mind?",
	"Did you really expect to win?",
	"What if the dark is its light?",
	"The rooms shift once again.",
	"The definition of insanity is doing the same action over and over again and expecting a different result",
	"Do I dare disturb the universe?",
	"In a minute there is time for decisions and revisions which a minute will reverse",
	"The price of looking into the abyss is that the abyss looks back into you.",
	"It’s not that you can't leave. It's that there's nowhere else to go.",
	"Wouldn't it be nice to give up? See the world?",
	"Is paying for your future with your present really worth it?",
	"Is it that you want to win? Or do you just not want to lose?"
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = $Text
	roomCounter = $RoomCtr
	roomCounter.text = "Rooms Survived: %s" % Globals.RoomOn
	var random_index = randi() % death_messages.size()
	chosenText = death_messages[random_index]
	
	text.text = ""
	typewriter_effect(chosenText)

func typewriter_effect(full_text: String) -> void:
	# Set the visible characters to 0 before setting the text
	text.visible_characters = 0
	text.text = full_text
	
	# Calculate duration based on text length (0.04 seconds per character)
	var duration = full_text.length() * 0.04
	
	# Create a tween to animate the visible_characters property
	var tween = create_tween()
	tween.tween_property(text, "visible_characters", full_text.length(), duration)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN_OUT)


func _on_again_pressed() -> void:
	Globals.lamp_health = 100
	Globals.battery = 100
	Globals.RoomOn = 1
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")



func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")
