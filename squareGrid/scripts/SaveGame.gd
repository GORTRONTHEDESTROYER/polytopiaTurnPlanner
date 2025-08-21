class_name SaveGame
extends Sprite2D
@onready var tileData = %TileMapHolder

func save_game():
	var saved_game:SavedGame = SavedGame.new()
	for x in range(tileData.gridSize):
		saved_game.allTiles.append([])
		for y in range(tileData.gridSize):
			var saved_tile:SavedGameSubTile = SavedGameSubTile.new()
			saved_tile.player = tileData.tiles[x][y].player
			saved_tile.type = tileData.tiles[x][y].type
			saved_tile.tribe = tileData.tiles[x][y].tribe
			saved_tile.building = tileData.tiles[x][y].building
			saved_tile.position = tileData.tiles[x][y].position
			saved_tile.typeHeld = tileData.tiles[x][y].typeHeld
			saved_tile.water = tileData.tiles[x][y].water
			saved_tile.road = tileData.tiles[x][y].road	
			saved_tile.resourceLevel = tileData.tiles[x][y].resourceLevel
			
			if tileData.tiles[x][y].unit != null:
			#	var saved_unit:unitSaver = unitSaver.new()
			
				#var saved_unit:unitSaver = unitSaver.new()
				#saved_unit.pos = tileData.tiles[x][y].position
				
				#saved_unit.type = tileData.tiles[x][y].unit.type
				#saved_unit.player = tileData.tiles[x][y].unit.player
				#saved_unit.active = tileData.tiles[x][y].unit.active
				saved_tile.addUnit(tileData.tiles[x][y].unit.type, 
					tileData.tiles[x][y].unit.player, 
					tileData.tiles[x][y].unit.active
					
					)
				#saved_tile.unit = saved_unit
				
				#saved_game.allUnits.append(saved_unit)
				#saved_game.allUnits.append([])
				
			saved_game.allTiles[x].append(saved_tile)

	ResourceSaver.save(saved_game, "res://savegame.tres", ResourceSaver.FLAG_NONE)


	#var saved_tile:SavedGameSubTile = SavedGameSubTile.new()

	#saved_tile.player = 10
	
	#saved_game.allTiles.append([])
	#saved_game.allTiles[0].append(saved_tile)
	#var saved_tile2:SavedGameSubTile = SavedGameSubTile.new()


	
	#saved_tile2.player = 12

	#saved_game.allTiles.append([])
	#saved_game.allTiles[1].append(saved_tile2)


	#var saved_tile:SavedGameSubTile = SavedGameSubTile.new()
	#print(tileData.tiles[0][2].position)
	#saved_game.tile = tileData.tiles[0][2]
	#saved_game.loadTile(tileData.tiles[0][2])
	#print(saved_game.tile.position)
	#saved_game.loadAllTiles()
#	saved_tile.tile = Tile.new(Constants.TileType.FIELD, Vector2i(0,0), Vector2i(0, 0), 0)
	#saved_game.allTiles.append([])
	#saved_game.allTiles[0].append(saved_tile.tile)
	#ResourceSaver.save(saved_tile, "res://savegame.tres")


func load_game():
	#var saved_game:SavedGameSubTile = load("res://savegame.tres") as SavedGameSubTile
	var saved_game:SavedGame = load("res://savegame.tres") as SavedGame

	for x in range(tileData.gridSize):
		for y in range(tileData.gridSize):
			tileData.tiles[x][y] = null
	tileData.tiles.clear()
	for x in range(tileData.gridSize):
		tileData.tiles.append([])

		for y in range(tileData.gridSize):
			tileData.tiles[x].append(
				Tile.new(Constants.TileType.FIELD, Vector2i(0,0), Vector2i(x, y), 0)
			)
			#tileData.tiles[x][y].position = Vector2i(0,0)
			tileData.tiles[x][y].zoneControl = 0
			tileData.tiles[x][y].loadData(saved_game.allTiles[x][y])
			if saved_game.allTiles[x][y].unit != null:
				tileData.tiles[x][y].unit = Unit.new()
				tileData.tiles[x][y].unit.unitLoad(saved_game.allTiles[x][y].unit)
				
			
	tileData.updateAllTileLook()
	tileData.updateAllUnitLook()

			
			
	
	#print(saved_game.allTiles[0][0].unit.getter())
	#print(saved_game.allTiles[0][0].unit.player)

	


	#print(saved_game.allTiles[0][0].unit.type)
	#tileData.tiles[0][0] = saved_game.allTiles[0][0]
#	tileData.updateAllTileLook()
