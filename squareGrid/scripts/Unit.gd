class_name Unit

var type: Constants.UnitType

var tribe: Constants.Tribe
var player: Constants.Player
var color: Vector2i = Vector2i(0,0)
var ready: bool = true
var active: bool = false
var movement: int = 0 

func _init(
	#typeP: Constants.UnitType,
	playerP: Constants.Player
):
	#type = typeP
	player = playerP
	
func typeWarrior(typeP: Constants.UnitType):
	type = typeP
	movement = 4
	#print(movement)
func typeRider(typeP: Constants.UnitType):
	type = typeP
	movement = 2
