class_name SavedGame
extends Resource

#@export var tile: Tile = null
@export var allTiles:Array[Array] = []

@export var player: Array = []
#@export var allUnits:Array[Resource] = []
#Resource.duplicate(true)

#func loadTile(tileP:Tile):
	#tile = tileP.duplicate(true)
	

#func loadAllTiles():
	#allTiles.append([])
	#allTiles[0].append(tile)
#	pass
