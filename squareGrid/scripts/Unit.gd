class_name Unit

var type: Constants.UnitType

#var tribe: Vector2i
var player: int
#var color: Vector2i = Vector2i(0,0)
var ready: bool = true
var active: bool = false

var movement: int = 0 
var health: float = 0
var attack: float = 0
var defense: float = 0
var unitRange: float = 0

var maxHealth: float = 0
var vet: bool = false


var flying = false

func _init(
	#typeP: Constants.UnitType,
	playerP: int = 0,
	healthP: int = 0
	
):
	#type = typeP
	player = playerP
	health = healthP
	
func unitLoad(saved_unit:unitSaver):
	#type = saved_unit.type
	player = saved_unit.player
	active = saved_unit.active
	health = saved_unit.health
	
	match saved_unit.type:
		Constants.UnitType.WARRIOR:
			typeWarrior(saved_unit.type)
		Constants.UnitType.RIDER:
			typeRider(saved_unit.type)
		Constants.UnitType.ARCHER:
			typeArcher(saved_unit.type)
		
	
func typeWarrior(typeP: Constants.UnitType):
	
	maxHealth = 10
	type = typeP
	movement = 1
	attack = 2
	defense= 2
	unitRange = 1
	#print(movement)
func typeRider(typeP: Constants.UnitType):
	
	maxHealth = 10
	type = typeP
	movement = 2
	attack = 2
	defense= 1
	unitRange = 1
	
func typeArcher(typeP: Constants.UnitType):
	
	maxHealth = 10
	type = typeP
	movement = 1
	attack = 2
	defense= 1
	unitRange = 2

func typeDefender(typeP: Constants.UnitType):
	
	maxHealth = 15
	type = typeP
	movement = 1
	attack = 1
	defense= 3
	unitRange = 1
	
func typeSwordsman(typeP: Constants.UnitType):
	
	maxHealth = 15
	type = typeP
	movement = 1
	attack = 3
	defense= 3
	unitRange = 1

func typeKnight(typeP: Constants.UnitType):
	
	maxHealth = 10
	type = typeP
	movement = 3
	attack = 3.5
	defense= 1
	unitRange = 1
	
func typeCatapult(typeP: Constants.UnitType):
	
	maxHealth = 10
	type = typeP
	movement = 1
	attack = 4
	defense= 0
	unitRange = 3
func typeMindbender(typeP: Constants.UnitType):
	maxHealth = 10
	type = typeP
	movement = 1
	attack = 0
	defense= 1
	unitRange = 1
func typeGiant(typeP: Constants.UnitType):
	
	maxHealth = 40
	type = typeP
	movement = 1
	attack = 5
	defense= 4
	unitRange = 1
