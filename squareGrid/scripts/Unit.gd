class_name Unit

var type: Constants.UnitType

var tribe: Constants.Tribe
var player: Constants.Player
var ready = true
var active = false
var movement = 0 

func _init(
	#typeP: Constants.UnitType,
	playerP: Constants.Player
):
	#type = typeP
	player = playerP
	
func typeWarrior(typeP: Constants.UnitType):
	type = typeP
	movement = 6
	#print(movement)
func typeRider(typeP: Constants.UnitType):
	type = typeP
	movement = 2
