class_name Tile
extends Resource
#generation
var player: int
var type: Constants.TileType
var tribe: Vector2i
var building: Constants.BuildingType
var position: Vector2i
var typeHeld: Constants.TileType
var water: bool

#Non-Tile Attributes
var roadHeld: Constants.BuildingType
var buildingHeld: Constants.BuildingType
var road: bool = false
var city : City = null
var cityTile: Vector2i #load with city position
var unit: Unit = null



#Movement
var movementDist: int = -1
var movementDistSource: int = -1
var spacer: int = -1
var moveableTile: bool = false
var zoneControl: int = 0 # 0 equals free, 1 equals adjacent tile, # 2 equals zone of control tile



var x: int:
	get:
		return position.x
	set(value):
		position.x = value
var y: int:
	get:
		return position.y
	set(value):
		position.y = value
var resourceLevel: int

func _init(
	typeP: Constants.TileType, 
	tribeP: Vector2i,
	posP: Vector2i,
	resP: int = 0
):
	type = typeP
	tribe = tribeP
	position = posP
	resourceLevel = resP

func loadData(saved_game:SavedGameSubTile):
	player = saved_game.player
	type = saved_game.typeHeld
	tribe = saved_game.tribe
	position = saved_game.position
	typeHeld = saved_game.typeHeld
	resourceLevel = saved_game.resourceLevel

	water = saved_game.water
	
	#if saved_game.road:
		#building = 
	building = saved_game.building

	
	roadHeld = saved_game.road
	
	#if saved_game.unit != null:
		
		
	
	
	
	
	
	
	
	
