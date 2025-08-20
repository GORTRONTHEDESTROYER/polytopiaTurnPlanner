class_name SavedGameSubTile
extends Resource


@export var player: int
@export var type: Constants.TileType
@export var tribe: Vector2i
@export var building: Constants.BuildingType
@export var position: Vector2i
@export var typeHeld: Constants.TileType
@export var resourceLevel: int
@export var water: bool
@export var road: bool = false

@export var unit: unitSaver

func addUnit(type, player, active):
	unit = unitSaver.new(type, player, active)
	unit.setter(type, player, active)
#	pass
