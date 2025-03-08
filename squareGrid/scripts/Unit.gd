class_name Unit

var type: Constants.UnitType

var tribe: Constants.Tribe
var player: Constants.Player
var ready = true
var active = false

func _init(
	typeP: Constants.UnitType,
	playerP: Constants.Player
):
	type = typeP
	player = playerP
	
