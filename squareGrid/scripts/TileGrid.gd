extends TileMap

const Camera2d = preload("res://scripts/Camera2D.gd")

enum Layer {TILE, RESOURCE, ROAD, BUILDING, UNIT_MOVE, UNIT, SELECTION}

var gridSize = 16
var tiles: Array[Array] = []

var state = State.new()

func get_tile(pos: Vector2i) -> Tile:
	if pos.x < 0 or pos.y < 0 or pos.x >= gridSize or pos.y >= gridSize:
		return null
	return tiles[pos.x][pos.y]

## Returns the full list of tiles within the specified [distance], with a default distance of 1 (directly adjacent tiles)
## .
## [pos]: The starting tile's position
## [incSelf]: Determines if this should also include the starting tile
func get_surrounding_tiles(pos: Vector2i, distance: int = 1, incSelf: bool = false) -> Array:
	return get_surrounding_tiles_xy(pos.x, pos.y, distance, incSelf)
	
## Returns the full list of tiles within the specified [distance], with a default distance of 1 (directly adjacent tiles)
## .
## [x], [y]: The starting tile's coordinates
## [incSelf]: Determines if this should also include the starting tile
func get_surrounding_tiles_xy(x: int, y: int, distance: int = 1, incSelf: bool = false) -> Array:
	var result: Array = []
	if incSelf: result.append(tiles[x][y])
	for i in range(1, distance + 1):
		var xNeg = x - i
		var xPos = x + i
		var yNeg = y - i
		var yPos = y + i
		var checkNegX = xNeg >= 0
		var checkPosX = xPos < gridSize
		var checkNegY = yNeg >= 0
		var checkPosY = yPos < gridSize
		if !checkNegX && !checkPosX: break
		if !checkNegY && !checkPosY: break
		if checkNegX && checkNegY:
			result.append(tiles[xNeg][yNeg])
		if checkPosX && checkNegY:
			result.append(tiles[xPos][yNeg])
		if checkNegX && checkPosY:
			result.append(tiles[xNeg][yPos])
		if checkPosX && checkPosY:
			result.append(tiles[xNeg][yNeg])
		var startX: int
		if checkNegX: startX = 0
		else: startX = 0 - xNeg
		var endX: int
		if checkPosX: endX = gridSize
		else: endX = 2 * gridSize - xPos
		var startY: int
		if checkNegY: startY = 0
		else: startY = 0 - yNeg
		var endY: int
		if checkPosY: endY = gridSize
		else: endY = 2 * gridSize - yPos
		for j in range(1, 2 * i):
			if(startX <= j && j <= endX):
				if checkNegY: result.append(tiles[xNeg + j][yNeg])
				if checkPosY: result.append(tiles[xNeg + j][yPos])
			if(startY <= j && j <= endY):
				if checkNegX: result.append(tiles[xNeg][yNeg + j])
				if checkPosX: result.append(tiles[xPos][yNeg + j])
	var dict: Dictionary = {}
	for i in result: dict[i] = true
	return dict.keys()

## Returns the full list of tiles one the outer edge the specified [distance], with a default distance of 1 (directly adjacent tiles)
## .
## [pos]: The starting tile's position
func get_outer_tiles(pos: Vector2i, distance: int = 1) -> Array:
	return get_outer_tiles_xy(pos.x, pos.y, distance)

## Returns the full list of tiles one the outer edge the specified [distance], with a default distance of 1 (directly adjacent tiles)
## .
## [x], [y]: The starting tile's coordinates
func get_outer_tiles_xy(x: int, y: int, distance: int = 1) -> Array:
	var result: Array = []
	var xNeg: int = x - distance
	var xPos: int = x + distance
	var yNeg: int = y - distance
	var yPos: int = y + distance
	var checkNegX: bool = xNeg >= 0
	var checkPosX: bool = xPos < gridSize
	var checkNegY: bool = yNeg >= 0
	var checkPosY: bool = yPos < gridSize
	if !checkNegX && !checkPosX: return result
	if !checkNegY && !checkPosY: return result
	if checkNegX && checkNegY:
		result.append(tiles[xNeg][yNeg])
	if checkPosX && checkNegY:
		result.append(tiles[xPos][yNeg])
	if checkNegX && checkPosY:
		result.append(tiles[xNeg][yPos])
	if checkPosX && checkPosY:
		result.append(tiles[xNeg][yNeg])
	var startX: int
	if checkNegX: startX = 0
	else: startX = 0 - xNeg
	var endX: int
	if checkPosX: endX = gridSize
	else: endX = 2 * gridSize - xPos
	var startY: int
	if checkNegY: startY = 0
	else: startY = 0 - yNeg
	var endY: int
	if checkPosY: endY = gridSize
	else: endY = 2 * gridSize - yPos
	for j in range(1, 2 * distance + 1):
		if(startX <= j && j <= endX):
			if checkNegY: result.append(tiles[xNeg + j][yNeg])
			if checkPosY: result.append(tiles[xNeg + j][yPos])
		if(startY <= j && j <= endY):
			if checkNegX: result.append(tiles[xNeg][yNeg + j])
			if checkPosX: result.append(tiles[xPos][yNeg + j])
	var dict: Dictionary = {}
	for i in result: dict[i] = true
	return dict.keys()

func _ready():
	for x in range(gridSize):
		tiles.append([])
		for y in range(gridSize):
			tiles[x].append(
				Tile.new(Constants.TileType.FIELD, Constants.Tribe.IMP, Vector2i(x, y))
			)
			
			set_cell(Layer.TILE, Vector2i(x, y), Constants.Asset.FIELD, Vector2i.ZERO, 0)

	#tiles[0][0].unit = Unit.new(Constants.UnitType.WARRIOR, Constants.Player.ONE)
	#tiles[0][1].unit = Unit.new(Constants.UnitType.WARRIOR, Constants.Player.ONE)
	#print(tiles[0][0].unit.type)
	#updateAllUnitLook()
	#updateUnitLook(tiles[0][0])
var prev_tile_pos: Vector2i = Vector2i(0, 0)

func _process(_delta):
	var positionC2 = get_viewport().get_camera_2d().position
	var mousePosition = get_viewport().get_mouse_position() + Vector2(0,10)
	var tile_pos: Vector2i = local_to_map(mousePosition + positionC2)

	erase_cell(6, prev_tile_pos)
	var tile = get_tile(tile_pos)
	
	if tile != null:
		set_cell(6, tile_pos, 0, Vector2i(0,0),0)
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
	tile.resourceLevel = resource_level_bt
	tile.type = tile_type_bt
	tile.building = building_type_bt
	

	
func updateLook(tile: Tile):

	match [tile.type, tile.resourceLevel]:
		[Constants.TileType.FIELD, 0]:
			tile.typeHeld = tile.type
			tile.zoneControl = 0
			set_cell(Layer.TILE, tile.position, Constants.Asset.FIELD, Vector2i.ZERO, 0)
			erase_cell(Layer.RESOURCE, tile.position)
		[Constants.TileType.FIELD, 1]:
			tile.typeHeld = tile.type
			tile.zoneControl = 0
			set_cell(Layer.TILE, tile.position, Constants.Asset.FIELD, Vector2i.ZERO, 0)
			set_cell(Layer.RESOURCE, tile.position, Constants.Asset.FRUIT, Vector2i.ZERO, 0)
		[Constants.TileType.FIELD, 2]:
			tile.typeHeld = tile.type
			tile.zoneControl = 0
			set_cell(Layer.TILE, tile.position, Constants.Asset.FIELD, Vector2i.ZERO, 0)
			set_cell(Layer.RESOURCE, tile.position, Constants.Asset.CROP, Vector2i.ZERO, 0)
		[Constants.TileType.FOREST, 1]:
			tile.typeHeld = tile.type
			tile.zoneControl = 1
			set_cell(Layer.TILE, tile.position, Constants.Asset.FOREST, Vector2i.ZERO, 0)
			set_cell(Layer.RESOURCE, tile.position, Constants.Asset.ANIMAL, Vector2i.ZERO, 0)
		[Constants.TileType.FOREST, _]:
			tile.typeHeld = tile.type
			tile.zoneControl = 1
			set_cell(Layer.TILE, tile.position, Constants.Asset.FOREST, Vector2i.ZERO, 0)
			erase_cell(Layer.RESOURCE, tile.position)
		[Constants.TileType.MOUNTAIN, 2]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.zoneControl = 1
			set_cell(Layer.TILE, tile.position, Constants.Asset.MOUNTAIN, Vector2i.ZERO, 0)
			set_cell(Layer.RESOURCE, tile.position, Constants.Asset.METAL, Vector2i.ZERO, 0)
			erase_cell(Layer.ROAD, tile.position)
		[Constants.TileType.MOUNTAIN, _]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.zoneControl = 1
			set_cell(Layer.TILE, tile.position, Constants.Asset.MOUNTAIN, Vector2i.ZERO, 0)
			erase_cell(Layer.RESOURCE, tile.position)
			erase_cell(Layer.ROAD, tile.position)
		[Constants.TileType.SHORES, _]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.zoneControl = 1
			set_cell(Layer.TILE, tile.position, Constants.Asset.SHORES, Vector2i.ZERO, 0)
			erase_cell(Layer.RESOURCE, tile.position)
			erase_cell(Layer.ROAD, tile.position)
		[Constants.TileType.OCEAN, _]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.zoneControl = 1
			set_cell(Layer.TILE, tile.position, Constants.Asset.OCEAN, Vector2i.ZERO, 0)
			erase_cell(Layer.RESOURCE, tile.position)
			erase_cell(Layer.ROAD, tile.position)
		[Constants.TileType.CLOUD, _]:
			tile.typeHeld = tile.type
			tile.zoneControl = 0
			tile.road = false
			set_cell(Layer.TILE, tile.position, Constants.Asset.CLOUD, Vector2i.ZERO, 0)
			erase_cell(Layer.RESOURCE, tile.position)
			erase_cell(Layer.ROAD, tile.position)
		_:
			pass
	#print(tile.type)
	#print(Constants.BuildingType.ROAD)
	match [tile.building, tile.typeHeld]: 
		[Constants.BuildingType.ROAD, Constants.TileType.MOUNTAIN]:
			tile.road = false
			erase_cell(Layer.ROAD, tile.position)
		[Constants.BuildingType.ROAD, _]:
			tile.road = true
			set_cell(Layer.ROAD, tile.position, Constants.Asset.ROAD, Vector2i.ZERO, 0)
		[Constants.BuildingType.RUIN, _]:
			tile.road = true
			set_cell(Layer.ROAD, tile.position, Constants.Asset.RUIN, Vector2i.ZERO, 0)
		[Constants.BuildingType.VILLAGE, _]:
				tile.road = true
				set_cell(Layer.ROAD, tile.position, Constants.Asset.VILLAGE, Vector2i.ZERO, 0)
	
	
			#erase_cell(Layer., tile.position)
			#set_cell(Layer.BUILDING, tile.position, Constants.Asset.ROAD, Vector2i.ZERO, 0)
			
			

func updateUnit(tile: Tile):
	match unit_type_bt:
		1: 
			tile.unit = Unit.new(Constants.Player.ONE)
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
				set_cell(Layer.UNIT, tileW.position, Constants.Asset.WARRIOR, Vector2i.ZERO, 0)
			_: 
				pass
	else:
		erase_cell(Layer.UNIT, tileW.position)
			
			

func turnMode(tile: Tile):
	if Input.is_action_just_pressed("LEFT_MOUSE_BUTTON"):
		if tile != null && tile.unit != null:
			
			if state.active_tile != null:
				state.active_tile.unit.active = false 
				clear_layer(Layer.UNIT_MOVE)
				
			tile.unit.active = not tile.unit.active
			
			if tile.unit.active:
				state.active_tile = tile
				drawPosibleUnitMoves(tile)
			else: 
				state.active_tile = null
				clear_layer(Layer.UNIT_MOVE)
			updateUnitLook(tile)
		
		
			
		elif state.active_tile != null && tile != null && get_cell_tile_data(Layer.UNIT_MOVE, tile.position):
			tile.unit = state.active_tile.unit 
			state.active_tile.unit = null
			updateUnitLook(state.active_tile)
			state.active_tile = null
			tile.unit.active = not tile.unit.active
			updateUnit(tile)
			clear_layer(Layer.UNIT_MOVE)
			
		elif tile != null && (state.active_tile != null):
			state.active_tile.unit.active = false 
			state.active_tile = null
			clear_layer(Layer.UNIT_MOVE)
			
			
var looper = 0		
func drawPosibleUnitMoves(tile: Tile):
	var movement = tile.unit.movement
	#tiles[0][0].zoneControl = 2
	#tiles[1][1].zoneControl = 2
	#tiles[2][2].zoneControl = 2
	tiles[1][6].zoneControl = 2
	
	roadTiles2((movement*2),tile.position)
	
	#roadTiles(movement*3,tile.position)
	tile.spacer = 0
	
	nextTiles2(movement*2, tile.position)
	print(looper)
	
	movement = movement * 2
	for x in range(((movement) * 3)): 
		for y in range(((movement) * 3)):
			var tileMoveDistClear = tile.position + Vector2i(x,y) - Vector2i(movement,movement)
			if(inBounds(tileMoveDistClear)):
				
				tiles[tileMoveDistClear.x][tileMoveDistClear.y].movementDist = -1
				#tiles[tileMoveDistClear.x][tileMoveDistClear.y].movementDistSource = -1
				tiles[tileMoveDistClear.x][tileMoveDistClear.y].spacer = -1
				
			

func nextTiles2(movement: int, vectorHoldPassed: Vector2i, stupid: bool = true):   #good luck reading this lmao
	#var roadHold = roadPassed
	#if(tiles[vectorHoldPassed.x][vectorHoldPassed.y].)
	movement = movement - 1 + tiles[vectorHoldPassed.x][vectorHoldPassed.y].spacer
	set_cell(Layer.UNIT_MOVE, vectorHoldPassed, Constants.Asset.MOVETARGET, Vector2i.ZERO, 0)

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
							#if(tiles[vectorHold.x][vectorHold.y].road && tiles[vectorHoldPassed.x][vectorHoldPassed.y].road):
							#	nextTiles2(movement, vectorHold)
						else:	
							if(get_cell_source_id(Layer.UNIT_MOVE,vectorHold)!=11):
								if(movement > 5):
									var zonepass = true
									for i in range(3):
										for j in range(3): 
											var vectorHold2 = vectorHold + Vector2i(i,j) - Vector2i(1,1) 
											if(inBounds(vectorHold2)):
												if(tiles[vectorHold2.x][vectorHold2.y].zoneControl == 2):
													set_cell(Layer.UNIT_MOVE, vectorHold2, Constants.Asset.ZOC2MOVETARGET, Vector2i.ZERO, 0)
													zonepass = false
									if(zonepass):
										nextTiles2(movement-4, vectorHold)
								#	nextTiles2(movement-4, vectorHold)
								set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.ZOC1MOVETARGET, Vector2i.ZERO, 0)
					elif(tiles[vectorHold.x][vectorHold.y].zoneControl == 2):
						pass
					else:
						for i in range(3):
							for j in range(3): 
								var vectorHold2 = vectorHold + Vector2i(i,j) - Vector2i(1,1) 
								if(inBounds(vectorHold2)):
									if(tiles[vectorHold2.x][vectorHold2.y].zoneControl == 2):
										set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.ZOC1MOVETARGET, Vector2i.ZERO, 0)
										set_cell(Layer.UNIT_MOVE, vectorHold2, Constants.Asset.ZOC2MOVETARGET, Vector2i.ZERO, 0)
										
						if(get_cell_source_id(Layer.UNIT_MOVE,vectorHold)!=12 && get_cell_source_id(Layer.UNIT_MOVE,vectorHold)!=13):
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

func getPossibleMoves(movement: int, unit: Unit, position: Vector2i, stupid: bool = true, drawImmediate: bool = false):
	var tilesToCheck: Array = []
	var movementUsed: Dictionary = {}
	for i in get_surrounding_tiles(position):
		var tile: Tile = i
		movementUsed[tile] = getMovementCost(unit, position, tile.position)
		tilesToCheck.push_back(tile)
	while !tilesToCheck.is_empty():
		var currentTile: Tile = tilesToCheck.pop_front()
		if currentTile == get_tile(position): continue
		var currentMovement: float = movementUsed[currentTile]
		if currentMovement >= movement: continue
		var neighbors: Vector2i = currentTile.position
		for i in neighbors:
			var tile: Tile = get_tile(i)
			var totalMovement: float = currentMovement + getMovementCost(unit, currentTile.position, tile.position)
			if movementUsed.get(tile) == null || totalMovement < movementUsed[tile]:
				movementUsed[tile] = totalMovement
				tilesToCheck.push_back(tile)
		
	
	
func getMovementCost(unit: Unit, startPosition: Vector2i, endPosition: Vector2i) -> float:
	if get_tile(startPosition).road && get_tile(endPosition).road: return .5
	else return 1

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
