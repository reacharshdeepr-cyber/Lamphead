extends Node

var dev_mode := false
var TotalRooms = 6
var Roomnum = randi_range(1, TotalRooms)
var RoomOn = 1
var loadingNextRoom:bool = false

var battery:float = 100
var lamp_health := 100
var lamp_stage := 100
var batteryChance:float = 0.25
var screwChance:float = 0.25
var LampOn:bool = true
var key_room = null
var monsterAggro:bool = false

func set_battery(value:float)-> void:
	battery = clamp(value, 0, lamp_health)
	_update_lamp_stage()
	
func batteryCollected()-> void:
	Globals.set_battery(battery + 60)
	Globals.set_lamp_health(lamp_health - 10)
	
func keyCollected()-> void:
	key_room = false
	
func set_lamp_health(value: int) -> void:
	lamp_health = clamp(value, 0, 100)
	battery = clamp(battery, 0, lamp_health)
	_update_lamp_stage()

func screwCollected()-> void:
	Globals.set_lamp_health(lamp_health + 20)

func _update_lamp_stage() -> void:
	if lamp_health > 80:
		lamp_stage = 100
	elif lamp_health > 60:
		lamp_stage = 80
	elif lamp_health > 40:
		lamp_stage = 60
	elif lamp_health > 20:
		lamp_stage = 40
	elif lamp_health > 0:
		lamp_stage = 20
	else:
		lamp_stage = 0
		
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if battery == 0 or LampOn == false:
		monsterAggro = true
	else:
		monsterAggro = false
		
func _flicker() -> void:
	LampOn = false
	await get_tree().create_timer(0.2).timeout
	LampOn = true
	await get_tree().create_timer(0.1).timeout
	LampOn = false
	await get_tree().create_timer(0.1).timeout
	LampOn = true
