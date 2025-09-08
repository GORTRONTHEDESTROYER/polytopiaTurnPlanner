class_name SavedGameSubTile
extends Resource


@export var player: int
@export var type: Constants.TileType
@export var tribe: Vector2i
@export var building: Constants.BuildingType
@export var road: Constants.BuildingType
@export var position: Vector2i
@export var typeHeld: Constants.TileType
@export var resourceLevel: int
@export var water: bool
#@export var road: bool = false

@export var unit: unitSaver

@export var city: City

#func addUnit(typeP, playerP, activeP):
#	unit = unitSaver.new(typeP, playerP, activeP)
#	unit.setter(typeP, playerP, activeP)
#	pass
