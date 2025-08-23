class_name SaveGame
extends Sprite2D
@onready var tileData = %TileMapHolder
@onready var player = %tribeSelectHeader
#var tileData.playerSelected.head
func save_game():
	var saved_game:SavedGame = SavedGame.new()
	
	saved_game.mapSize = Global.gridSize
	
	for x in tileData.playerSelected.head.size():
		#var intChange = x
		#intChange = int(intChange)
		#print("player")
#		print(player.head[1].player)
		var saved_player:playerSaver = playerSaver.new()
		saved_player.player = player.head[x].player
		saved_player.tribe = player.head[x].tribe
		saved_player.color = player.head[x].color
		saved_player.diplo = player.head[x].diplo.duplicate()
		saved_game.player.append(saved_player)
	
	
	
	for x in range(tileData.gridSize):
		saved_game.allTiles.append([])
		for y in range(tileData.gridSize):
			var saved_tile:SavedGameSubTile = SavedGameSubTile.new()
			saved_tile.player = tileData.tiles[x][y].player
			saved_tile.type = tileData.tiles[x][y].type
			saved_tile.tribe = tileData.tiles[x][y].tribe
			saved_tile.building = tileData.tiles[x][y].buildingHeld
			saved_tile.position = tileData.tiles[x][y].position
			saved_tile.typeHeld = tileData.tiles[x][y].typeHeld
			saved_tile.water = tileData.tiles[x][y].water
			saved_tile.road = tileData.tiles[x][y].roadHeld
			saved_tile.resourceLevel = tileData.tiles[x][y].resourceLevel
			
			if tileData.tiles[x][y].unit != null:
			#	var saved_unit:unitSaver = unitSaver.new()
			
				#var saved_unit:unitSaver = unitSaver.new()
				#saved_unit.pos = tileData.tiles[x][y].position
				
				#saved_unit.type = tileData.tiles[x][y].unit.type
				#saved_unit.player = tileData.tiles[x][y].unit.player
				#saved_unit.active = tileData.tiles[x][y].unit.active
				saved_tile.unit = unitSaver.new()
				saved_tile.unit.type = tileData.tiles[x][y].unit.type
				saved_tile.unit.player = tileData.tiles[x][y].unit.player
				saved_tile.unit.active = tileData.tiles[x][y].unit.active
				saved_tile.unit.health = tileData.tiles[x][y].unit.health
				
				
				#.type =  tileData.tiles[x][y].unit.type
			#	tileData.tiles[x][y].unit.type, 
			#		tileData.tiles[x][y].unit.player, 
				#	tileData.tiles[x][y].unit.active,
				#	tileData.tiles[x][y].unit.health
				
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
	
	for x in Global.players:
		player.head[x].diplo.clear()

#	print("length")
#	print(len(saved_game.player))
	Global.players = len(saved_game.player)
	
	#print(Global.players)
	player.head.clear()
	player.loadReady()
	for x in Global.players:

		var yHold: int = 0
		for y in Global.players:
			
			if saved_game.player[y].player == x:
				yHold = y
				break
	#	player.head[x].player = player.h
	#	print("index")
	#	print(len(player.head))
		player.head[x].tribe = saved_game.player[yHold].tribe
		player.head[x].color = saved_game.player[yHold].color
		player.head[x].diplo = saved_game.player[yHold].diplo
		player.TileMapHS.update(player.head[x])
	player.TileMapHS.hideUnselected(Global.players)
	player.hid = true
	

	for x in range(tileData.gridSize):
		for y in range(tileData.gridSize):
			tileData.tiles[x][y] = null
			#tileData.tiles[x][y].buildings = Constants.TileType.NONE
			tileData.buildingLayer.clear()
			tileData.buildingRoad.clear()

			
	tileData.tiles.clear()
	
	tileData.gridSize = saved_game.mapSize
	tileData.baseLayer.clear()

	
	
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
				
	##################################################################################
	tileData.updateAllTileLook(true)
	tileData.updateAllUnitLook()
#	print(Global.players)
	
	
	
	#	player.head[x].tribe = saved_game.player[y].tribe

		#	pass
			
	#	saved_player.player = player.head[x].player
	#	saved_player.tribe = player.head[x].tribe
	#	saved_player.color = player.head[x].color
	#	saved_player.diplo = player.head[x].diplo.duplicate()
		#pass

			
			
	
	#print(saved_game.allTiles[0][0].unit.getter())
	#print(saved_game.allTiles[0][0].unit.player)

	


	#print(saved_game.allTiles[0][0].unit.type)
	#tileData.tiles[0][0] = saved_game.allTiles[0][0]
#	tileData.updateAllTileLook()
