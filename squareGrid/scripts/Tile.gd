class_name Tile
extends Resource

var type: Constants.TileType
var tribe: Constants.Tribe
var position: Vector2i

var unit: Unit = null
var moveableTile = false
var zoneControl = 0 # 0 equals free, 1 equals adjacent tile, # 2 equals zone of control tile

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
	tribeP: Constants.Tribe,
	posP: Vector2i,
	resP: int = 0
):
	type = typeP
	tribe = tribeP
	position = posP
	resourceLevel = resP
