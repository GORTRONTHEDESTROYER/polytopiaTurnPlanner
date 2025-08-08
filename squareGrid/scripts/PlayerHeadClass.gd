class_name PlayerHead
var player: int
var tribe: Vector2i
var color: Vector2i
var location: int
var diplo: Array

func _init(
	playerP,
	tribeP,
	colorP,
	locationP
):
	
	player = playerP	
	tribe = tribeP
	color = colorP
	location = locationP
	
func printer():
	print(player)
	
func finder():
	if location == 0:
		return true
	else:
		return false
func finderInt():
	return location
