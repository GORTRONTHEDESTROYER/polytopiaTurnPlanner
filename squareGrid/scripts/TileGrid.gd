extends Node2D

const Camera2d = preload("res://scripts/Camera2D.gd")

var players : int = Global.players

enum Layer {TILE, RESOURCE, ROAD, BUILDING, UNIT_MOVE, UNITBODY, UNITHEAD, SELECTION}

var gridSize: int = Global.gridSize
var tiles: Array[Array] = []
var state = State.new()

@export var playerSelected: NinePatchRect

@export var baseLayer: TileMapLayer
@export var resourceLayer: TileMapLayer
@export var buildingRoad: TileMapLayer
@export var buildingLayer: TileMapLayer
@export var unitMoveLayer: TileMapLayer
@export var unitHead: TileMapLayer
@export var unitLayer: TileMapLayer
@export var cloudsLayer: TileMapLayer
@export var selectionLayer: TileMapLayer






func get_tile(pos: Vector2i) -> Tile:
	if pos.x < 0 or pos.y < 0 or pos.x >= gridSize or pos.y >= gridSize:
		return null
	return tiles[pos.x][pos.y]
	
#func get_Map_Setup_Data(mapSizeSliderScene, TileGridScene):
	

func _ready():
	for x in range(gridSize):
		tiles.append([])
		for y in range(gridSize):
			tiles[x].append(
				Tile.new(Constants.TileType.FIELD, Vector2i(0,0), Vector2i(x, y), 0)
			)
			
			baseLayer.set_cell(Vector2i(x, y), 0, Vector2i.ZERO, 0)

	#tiles[0][0].unit = Unit.new(Constants.UnitType.WARRIOR, Constants.Player.ONE)
	#tiles[0][1].unit = Unit.new(Constants.UnitType.WARRIOR, Constants.Player.ONE)
	#print(tiles[0][0].unit.type)
	#updateAllUnitLook()
	#updateUnitLook(tiles[0][0])
var prev_tile_pos: Vector2i = Vector2i(0, 0)

func _process(_delta):
	var positionC2 = get_viewport().get_camera_2d().position
	var mousePosition = get_viewport().get_mouse_position() + Vector2(0,10)
	var tile_pos: Vector2i = baseLayer.local_to_map(mousePosition + positionC2)

	#print(playerSelected.selected().player)
	selectionLayer.erase_cell(prev_tile_pos)
	var tile = get_tile(tile_pos)
	
	#print(tile_type_bt)
	#tile_type_bt = 1
	if tile != null:
		selectionLayer.set_cell(tile_pos, 0, Vector2i(0,0),0)
		#print("distSource")
	#	print(tiles[tile_pos.x][tile_pos.y].movementDistSource)
		#print("spacer")
	#	print(tiles[tile_pos.x][tile_pos.y].spacer)
		#print(tiles[tile_pos.x][tile_pos.y].road)
		prev_tile_pos = tile_pos

		if Input.is_action_pressed("LEFT_MOUSE_BUTTON")&&(mode == 0):
			updateTile(tile)
			updateLook(tile)
			updateUnit(tile)
	if mode == 1:
		turnMode(tile)
		

var tile_type_bt = Constants.TileType.NONE
var building_type_bt = Constants.BuildingType.NONE

var mode = 0

#Buttons Moved to Bottom
		
func updateTile(tile: Tile):
	var player = playerSelected.selected()
	tile.player = player.player
	tile.resourceLevel = resource_level_bt
	tile.type = tile_type_bt
	tile.building = building_type_bt
	

	
func updateLook(tile: Tile):

	match [tile.type, tile.resourceLevel]:
		[Constants.TileType.FIELD, 0]:
			tile.typeHeld = tile.type
			tile.zoneControl = 0
			baseLayer.set_cell(tile.position, 0, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.erase_cell(tile.position)
		[Constants.TileType.FIELD, 1]:
			tile.typeHeld = tile.type
			tile.zoneControl = 0
			resourceLayer.erase_cell(tile.position)
			baseLayer.set_cell(tile.position, 1, playerSelected.head[tile.player].tribe, 0)

		[Constants.TileType.FIELD, 2]:
			tile.typeHeld = tile.type
			tile.zoneControl = 0
			baseLayer.set_cell(tile.position, 0, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.set_cell( tile.position, 0, Vector2i.ZERO, 0)
		[Constants.TileType.FIELD, 3]:
			tile.typeHeld = tile.type
			tile.zoneControl = 0
			baseLayer.set_cell(tile.position, 0, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.set_cell( tile.position, 2, Vector2i(4,0), 0)
		[Constants.TileType.FOREST, 1]:
			tile.typeHeld = tile.type
			tile.zoneControl = 1
			resourceLayer.erase_cell(tile.position)

			baseLayer.set_cell(tile.position, 3, playerSelected.head[tile.player].tribe, 0)
			#resourceLayer.set_cell( tile.position, Constants.Asset.ANIMAL, Vector2i.ZERO, 0)
		[Constants.TileType.FOREST, 3]:
			tile.typeHeld = tile.type
			tile.zoneControl = 1
			baseLayer.set_cell(tile.position, 2, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.set_cell( tile.position, 2, Vector2i(4,0), 0)
		[Constants.TileType.FOREST, _]:
			tile.typeHeld = tile.type
			tile.zoneControl = 1
			baseLayer.set_cell(tile.position, 2, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.erase_cell( tile.position)
		[Constants.TileType.MOUNTAIN, 2]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.zoneControl = 1
			baseLayer.set_cell( tile.position, 4, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.set_cell(tile.position, 1, Vector2i.ZERO, 0)
			buildingRoad.erase_cell( tile.position)
		[Constants.TileType.MOUNTAIN, 3]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.zoneControl = 1
			baseLayer.set_cell(tile.position, 4, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.set_cell( tile.position, 2, Vector2i(4,0), 0)
		[Constants.TileType.MOUNTAIN, _]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.zoneControl = 1
			baseLayer.set_cell(tile.position, 4, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.erase_cell(tile.position)
			buildingRoad.erase_cell( tile.position)
		[Constants.TileType.SHORES, 1]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.zoneControl = 3
			baseLayer.set_cell(tile.position, 5, Vector2i(1,0), 0)
			resourceLayer.erase_cell(tile.position)
			buildingRoad.erase_cell( tile.position)
		[Constants.TileType.SHORES, 3]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.zoneControl = 3
			baseLayer.set_cell(tile.position, 5, Vector2i(3,0), 0)
			resourceLayer.set_cell(tile.position, 2, Vector2i(0,0), 0)
		[Constants.TileType.SHORES, _]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.zoneControl = 3
			baseLayer.set_cell(tile.position, 5, Vector2i(3,0), 0)
			resourceLayer.erase_cell(tile.position)
			buildingRoad.erase_cell( tile.position)
		[Constants.TileType.OCEAN, 1]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.zoneControl = 3
			baseLayer.set_cell( tile.position, 5, Vector2i(0,0), 0)
			resourceLayer.erase_cell(tile.position)
			buildingRoad.erase_cell( tile.position)
		[Constants.TileType.OCEAN, 3]:
			tile.typeHeld = tile.type
			tile.road = false

			tile.zoneControl = 3
			baseLayer.set_cell( tile.position, 5, Vector2i(2,0), 0)
			resourceLayer.set_cell( tile.position, 2, Vector2i(0,0), 0)
		[Constants.TileType.OCEAN, _]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.zoneControl = 3
			baseLayer.set_cell( tile.position, 5, Vector2i(2,0), 0)
			resourceLayer.erase_cell(tile.position)
			buildingRoad.erase_cell( tile.position)
		[Constants.TileType.CLOUD, _]:
			tile.typeHeld = tile.type
			tile.zoneControl = 0
			tile.road = false
			baseLayer.set_cell( tile.position, 6, Vector2i.ZERO, 0)
			resourceLayer.erase_cell(tile.position)
			buildingRoad.erase_cell( tile.position)
		_:
			pass
	#print(tile.type)
	#print(Constants.BuildingType.ROAD)
	match [tile.building, tile.typeHeld]: 
		[Constants.BuildingType.ROAD, Constants.TileType.MOUNTAIN]:
			tile.road = false
			buildingRoad.erase_cell( tile.position)
		[Constants.BuildingType.ROAD, _]:
			tile.road = true
			buildingRoad.set_cell( tile.position, Constants.Asset.ROAD, Vector2i.ZERO, 0)
		[Constants.BuildingType.RUIN, _]:
			print("tester")

			tile.road = false
			buildingLayer.set_cell( tile.position, 0, Vector2i.ZERO, 0)
		[Constants.BuildingType.VILLAGE, _]:
			print("tester")
			tile.road = true
			buildingLayer.set_cell( tile.position, 1, Vector2i.ZERO, 0)
			
			#erase_cell(Layer., tile.position)
			#set_cell(Layer.BUILDING, tile.position, Constants.Asset.ROAD, Vector2i.ZERO, 0)
func updateAllTileLook():
	for x in range(gridSize):
				for y in range(gridSize):
					updateLook(tiles[x][y])
			
			

func updateUnit(tile: Tile):
	match unit_type_bt:
		1: 
			var player = playerSelected.selected()
			#tile.unit.player = player.player
			
			tile.unit = Unit.new(player.player)
			
			tile.unit.typeWarrior(Constants.UnitType.WARRIOR)
		_:
			pass
	updateUnitLook(tile)

func updateAllUnitLook():
	for x in range(gridSize):
			for y in range(gridSize):
				updateUnitLook(tiles[x][y])
				

	

func updateUnitLook(tileW: Tile):
	
	if tileW.unit != null:
		
		match tileW.unit.type:
			Constants.UnitType.WARRIOR:
				
				unitHead.set_cell( tileW.position, Constants.Asset.UNITBODY, playerSelected.head[tileW.unit.player].color, 0)
				unitLayer.set_cell( tileW.position, Constants.Asset.UNITHEAD, playerSelected.head[tileW.unit.player].tribe, 0)

			_: 
				pass
	else:
		unitLayer.erase_cell(tileW.position)
		unitHead.erase_cell(tileW.position)

		
			
			

func turnMode(tile: Tile):
	if Input.is_action_just_pressed("LEFT_MOUSE_BUTTON"):
		if tile != null && tile.unit != null:
			
			if state.active_tile != null:
				state.active_tile.unit.active = false 
				unitMoveLayer.clear_layer()
				
			tile.unit.active = not tile.unit.active
			
			if tile.unit.active:
				state.active_tile = tile
				drawPosibleUnitMoves(tile)
			else: 
				state.active_tile = null
				unitMoveLayer.clear_layer()
			updateUnitLook(tile)
		
		
			
		elif state.active_tile != null && tile != null && unitMoveLayer.get_cell_tile_data(tile.position):
			tile.unit = state.active_tile.unit 
			state.active_tile.unit = null
			updateUnitLook(state.active_tile)
			state.active_tile = null
			tile.unit.active = not tile.unit.active
			updateUnit(tile)
			unitMoveLayer.clear_layer()
			
		elif tile != null && (state.active_tile != null):
			state.active_tile.unit.active = false 
			state.active_tile = null
			unitMoveLayer.clear_layer()
			
			
var looper = 0		
func drawPosibleUnitMoves(tile: Tile):
	var movement = tile.unit.movement
	tiles[1][6].zoneControl = 2
	var flying = false
	var creep = false
	
	
	if(!flying && !creep):
		roadTiles2((movement*2),tile.position)
	
	#roadTiles(movement*3,tile.position)
	tile.spacer = 0
	
	movementRevamp(movement*2, tile.position)
	print(looper)
	
	movement = movement * 2
	for x in range(((movement) * 3)): 
		for y in range(((movement) * 3)):
			var tileMoveDistClear = tile.position + Vector2i(x,y) - Vector2i(movement,movement)
			if(inBounds(tileMoveDistClear)):
				
				tiles[tileMoveDistClear.x][tileMoveDistClear.y].movementDist = -1
				tiles[tileMoveDistClear.x][tileMoveDistClear.y].spacer = -1
				
func movementRevamp(movement: int, vectorHoldPassed: Vector2i, stupid: bool = true):	
	var sneak = false
	var creep = false
	var amphibious  = false
	var water = false
	var flying = true
	
	movement = movement - 1 + tiles[vectorHoldPassed.x][vectorHoldPassed.y].spacer

		
	#sets the tile to movable
	unitMoveLayer.set_cell(vectorHoldPassed, Constants.Asset.MOVETARGET, Vector2i.ZERO, 0)
	if(movement >= 0):
		#gets access to adjacent tiles
		for x in range(3):
			for y in range(3):
				#holds position of adjacent tile
				var vectorHold: Vector2i = vectorHoldPassed + Vector2i(x,y) - Vector2i(1,1)
				
				
				if(!inBounds(vectorHold)):
					continue  
				if(tiles[vectorHold.x][vectorHold.y].zoneControl == 2):
					continue  
				#water movement
				if((tiles[vectorHold.x][vectorHold.y].zoneControl == 3) && (!amphibious && !water && !flying)):
					continue
				if(tiles[vectorHold.x][vectorHold.y].zoneControl != 3) && water:
					unitMoveLayer.set_cell( vectorHold, 28, Vector2i.ZERO, 0)
					continue
				if(tiles[vectorHold.x][vectorHold.y].zoneControl < 3) && amphibious:
					unitMoveLayer.set_cell( vectorHold, Constants.Asset.MOVETARGET, Vector2i.ZERO, 0)
					continue
					
				
				if(tiles[vectorHold.x][vectorHold.y].zoneControl == 1) && (!creep && !flying):
					roughTerrain(vectorHold,vectorHoldPassed,movement,stupid)
					continue  
				if(sneak == false):
					zoneOfControl(vectorHold)
					
				if(unitMoveLayer.get_cell_source_id(vectorHold)!=12 && unitMoveLayer.get_cell_source_id(vectorHold)!=13):
					if(movement>tiles[vectorHold.x][vectorHold.y].movementDist):
						tiles[vectorHold.x][vectorHold.y].movementDist = movement
						movementRevamp(movement, vectorHold)
					if(tiles[vectorHold.x][vectorHold.y].road && tiles[vectorHoldPassed.x][vectorHoldPassed.y].road && (!flying && !creep)):
						print(flying)
						roadRec(vectorHold,vectorHoldPassed,movement,stupid)
					
					
				
				
func zoneOfControl(vectorHold):
	for i in range(3):
		for j in range(3): 
			var vectorHold2 = vectorHold + Vector2i(i,j) - Vector2i(1,1) 
			if(inBounds(vectorHold2)):
				if(tiles[vectorHold2.x][vectorHold2.y].zoneControl == 2):
					unitMoveLayer.set_cell( vectorHold, Constants.Asset.ZOC1MOVETARGET, Vector2i.ZERO, 0)
					unitMoveLayer.set_cell( vectorHold2, Constants.Asset.ZOC2MOVETARGET, Vector2i.ZERO, 0)

				
					
func roughTerrain(vectorHold,vectorHoldPassed,movement,stupid):
	if(tiles[vectorHold.x][vectorHold.y].road && tiles[vectorHoldPassed.x][vectorHoldPassed.y].road):
		if(tiles[vectorHold.x][vectorHold.y].spacer == -1 && tiles[vectorHoldPassed.x][vectorHoldPassed.y].spacer == -1):
			movementRevamp(movement+1, vectorHold)
		elif(tiles[vectorHold.x][vectorHold.y].movementDistSource == tiles[vectorHoldPassed.x][vectorHoldPassed.y].movementDistSource):
			if(stupid == true):
				movementRevamp(movement+1, vectorHold, false)
		else:
			movementRevamp(movement, vectorHold)
	else:	
		if(unitMoveLayer.get_cell_source_id(vectorHold)!=11):
			if(movement > 5):
				var zonepass = true
				for i in range(3):
					for j in range(3): 
						var vectorHold2 = vectorHold + Vector2i(i,j) - Vector2i(1,1) 
						if(inBounds(vectorHold2)):
							if(tiles[vectorHold2.x][vectorHold2.y].zoneControl == 2):
								unitMoveLayer.set_cell( vectorHold2, Constants.Asset.ZOC2MOVETARGET, Vector2i.ZERO, 0)
								zonepass = false
				#terminal tiles
				if(zonepass):
					movementRevamp(movement-4, vectorHold)
			#	nextTiles2(movement-4, vectorHold)
			unitMoveLayer.set_cell( vectorHold, Constants.Asset.ZOC1MOVETARGET, Vector2i.ZERO, 0)

func roadRec(vectorHold,vectorHoldPassed,movement,stupid):
	if(tiles[vectorHold.x][vectorHold.y].spacer == -1 && tiles[vectorHoldPassed.x][vectorHoldPassed.y].spacer == -1):
		movementRevamp(movement+1, vectorHold)
	elif(tiles[vectorHold.x][vectorHold.y].movementDistSource == tiles[vectorHoldPassed.x][vectorHoldPassed.y].movementDistSource):
		if(stupid == true):
			movementRevamp(movement+1, vectorHold, false)

				
	

func nextTiles2(movement: int, vectorHoldPassed: Vector2i, stupid: bool = true):   #good luck reading this lmao
	#var roadHold = roadPassed
	#if(tiles[vectorHoldPassed.x][vectorHoldPassed.y].)
	movement = movement - 1 + tiles[vectorHoldPassed.x][vectorHoldPassed.y].spacer
	unitMoveLayer.set_cell( vectorHoldPassed, Constants.Asset.MOVETARGET, Vector2i.ZERO, 0)

	if(movement >= 0):
		for x in range(3):
			for y in range(3):
				
				var vectorHold: Vector2i = vectorHoldPassed + Vector2i(x,y) - Vector2i(1,1)
				if(inBounds(vectorHold)):
					if(tiles[vectorHold.x][vectorHold.y].zoneControl == 1):
						if(tiles[vectorHold.x][vectorHold.y].road && tiles[vectorHoldPassed.x][vectorHoldPassed.y].road):
							if(tiles[vectorHold.x][vectorHold.y].spacer == -1 && tiles[vectorHoldPassed.x][vectorHoldPassed.y].spacer == -1):
								nextTiles2(movement+1, vectorHold)
							elif(tiles[vectorHold.x][vectorHold.y].movementDistSource == tiles[vectorHoldPassed.x][vectorHoldPassed.y].movementDistSource):
								if(stupid == true):
									nextTiles2(movement+1, vectorHold, false)
							else:
								nextTiles2(movement, vectorHold)
						else:	
							if(unitMoveLayer.get_cell_source_id(vectorHold)!=11):
								if(movement > 5):
									var zonepass = true
									for i in range(3):
										for j in range(3): 
											var vectorHold2 = vectorHold + Vector2i(i,j) - Vector2i(1,1) 
											if(inBounds(vectorHold2)):
												if(tiles[vectorHold2.x][vectorHold2.y].zoneControl == 2):
													unitMoveLayer.set_cell( vectorHold2, Constants.Asset.ZOC2MOVETARGET, Vector2i.ZERO, 0)
													zonepass = false
									if(zonepass):
										nextTiles2(movement-4, vectorHold)
								#	nextTiles2(movement-4, vectorHold)
								unitMoveLayer.set_cell( vectorHold, Constants.Asset.ZOC1MOVETARGET, Vector2i.ZERO, 0)
					elif(tiles[vectorHold.x][vectorHold.y].zoneControl == 2):
						pass
					else:
						for i in range(3):
							for j in range(3): 
								var vectorHold2 = vectorHold + Vector2i(i,j) - Vector2i(1,1) 
								if(inBounds(vectorHold2)):
									if(tiles[vectorHold2.x][vectorHold2.y].zoneControl == 2):
										unitMoveLayer.set_cell( vectorHold, Constants.Asset.ZOC1MOVETARGET, Vector2i.ZERO, 0)
										unitMoveLayer.set_cell( vectorHold2, Constants.Asset.ZOC2MOVETARGET, Vector2i.ZERO, 0)
										
						if(unitMoveLayer.get_cell_source_id(vectorHold)!=12 && unitMoveLayer.get_cell_source_id(vectorHold)!=13):
							if(movement>tiles[vectorHold.x][vectorHold.y].movementDist):
								#looper = looper + 1
								tiles[vectorHold.x][vectorHold.y].movementDist = movement
								nextTiles2(movement, vectorHold)
						
							if(tiles[vectorHold.x][vectorHold.y].road && tiles[vectorHoldPassed.x][vectorHoldPassed.y].road):
									if(tiles[vectorHold.x][vectorHold.y].spacer == -1 && tiles[vectorHoldPassed.x][vectorHoldPassed.y].spacer == -1):
										nextTiles2(movement+1, vectorHold)
									elif(tiles[vectorHold.x][vectorHold.y].movementDistSource == tiles[vectorHoldPassed.x][vectorHoldPassed.y].movementDistSource):
										if(stupid == true):
											nextTiles2(movement+1, vectorHold, false)
						

func roadTiles2(movement: int, vectorHoldPassed: Vector2i):
	
	for x in range(((movement*2) +1)): 
		for y in range(((movement*2) +1)):
			var vectorHold = vectorHoldPassed + Vector2i(x,y) - Vector2i(movement,movement)
			
			if(inBounds(vectorHold)): #####################################################
				var xDiff = vectorHold.x - vectorHoldPassed.x
				var yDiff = vectorHold.y - vectorHoldPassed.y
				var diff = 0
				
				if xDiff < 0:
					xDiff = xDiff * -1
				if yDiff < 0:
					yDiff = yDiff * -1
				#print(xDiff)
				#print(yDiff)
				if yDiff == xDiff:
					diff = yDiff
				elif yDiff > xDiff:
					diff = yDiff
				else:
					diff = xDiff
				#print(diff)
				tiles[vectorHold.x][vectorHold.y].movementDistSource = movement - diff
				tiles[vectorHold.x][vectorHold.y].spacer = -1
				#print(tiles[vectorHold.x][vectorHold.y].movementDist)
				#var tileMoveDistClear = vectorHoldPassed + Vector2i(x,y) - Vector2i(movement,movement)
	for x in range(((movement*2) +1)): 
		for y in range(((movement*2) +1)):
			var vectorHold = vectorHoldPassed + Vector2i(x,y) - Vector2i(movement,movement)
			if(inBounds(vectorHold)):
				for i in range (3):
					for j in range(3):
						var vectorHold2 = vectorHold + Vector2i(i,j) - Vector2i(1,1)
						if(inBounds(vectorHold2)):
							if(tiles[vectorHold.x][vectorHold.y].road && tiles[vectorHold2.x][vectorHold2.y].road):
								if(tiles[vectorHold.x][vectorHold.y].movementDistSource > tiles[vectorHold2.x][vectorHold2.y].movementDistSource):
									if(tiles[vectorHold.x][vectorHold.y].road && tiles[vectorHold2.x][vectorHold2.y].road):
										tiles[vectorHold2.x][vectorHold2.y].spacer = 0

func inBounds(vectorPassed):
	if (vectorPassed.x > -1 && vectorPassed.y > -1):
		if(vectorPassed.x < gridSize && vectorPassed.y < gridSize):
			return true
	return false

func _on_mountain_button_toggled(toggled_on: bool):
	if toggled_on:
		tile_type_bt = Constants.TileType.MOUNTAIN
	else:
		tile_type_bt = Constants.TileType.NONE	

func _on_field_button_toggled(toggled_on: bool):
	if toggled_on:
		tile_type_bt = Constants.TileType.FIELD
	else:
		tile_type_bt = Constants.TileType.NONE	 
	
func _on_forest_button_toggled(toggled_on: bool):
	if toggled_on:
		tile_type_bt = Constants.TileType.FOREST
	else:
		tile_type_bt = Constants.TileType.NONE	
		
func _on_cloudglidder_toggled(toggled_on: bool):
	if toggled_on:
		tile_type_bt = Constants.TileType.CLOUD
	else:
		tile_type_bt = Constants.TileType.NONE

var resource_level_bt = 0

func _on_tier_one_toggled(toggled_on: bool):
		
	if toggled_on:
		resource_level_bt = 1 
	else:
		resource_level_bt = 0

func _on_tier_two_toggled(toggled_on: bool):
		
	if toggled_on:
		resource_level_bt = 2 
	else:
		resource_level_bt = 0 
		
func _on_toggle_play_toggled(toggled_on: bool):
	if toggled_on:
		mode = 1
	else:
		mode = 0 
			

var unit_type_bt = Constants.UnitType.NONE

func _on_warrior_spawn_toggled(toggled_on: bool):
	if toggled_on:
		unit_type_bt = Constants.UnitType.WARRIOR
	else:
		unit_type_bt = Constants.UnitType.NONE
	#print(unit)
	

func _on_road_button_toggled(toggled_on: bool):
	if toggled_on:
		building_type_bt = Constants.BuildingType.ROAD
	else:
		building_type_bt = Constants.BuildingType.NONE
	#print(building_type_bt)

func _on_shores_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		tile_type_bt = Constants.TileType.SHORES
	else:
		tile_type_bt = Constants.TileType.NONE	
			
func _on_ocean_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		tile_type_bt = Constants.TileType.OCEAN
	else:
		tile_type_bt = Constants.TileType.NONE	
func _on_ruin_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		building_type_bt = Constants.BuildingType.RUIN
	else:
		building_type_bt = Constants.BuildingType.NONE

func _on_village_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		building_type_bt = Constants.BuildingType.VILLAGE
	else:
		building_type_bt = Constants.BuildingType.NONE
