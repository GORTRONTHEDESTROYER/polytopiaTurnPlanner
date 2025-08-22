class_name unitSaver
extends Resource

#@export var pos: Vector2i

@export var type: Constants.UnitType
@export var player: int
@export var active: bool = false
@export var health: int


#func _init(tyepP:Constants.UnitType = Constants.UnitType.NONE,playerP:int = 0,activeP:bool = false):
	#type = tyepP 
	#player = playerP
	#active = activeP
	
	
#func setter(tyepP:Constants.UnitType ,playerP:int ,activeP:bool):
#	type = tyepP 
#	player = playerP
#	active = activeP
	
#func getter():
	#return player
