extends TileMap

const Camera2d = preload("res://scripts/Camera2D.gd")

enum Layer {TILE, RESOURCE, UNIT_MOVE, UNIT, SELECTION}

var gridSize = 22
var tiles: Array[Array] = []

var state = State.new()

func get_tile(pos: Vector2i) -> Tile:
	if pos.x < 0 or pos.y < 0 or pos.x >= gridSize or pos.y >= gridSize:
		return null
	return tiles[pos.x][pos.y]

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
	updateAllUnitLook()
	#updateUnitLook(tiles[0][0])
var prev_tile_pos: Vector2i = Vector2i(0, 0)

func _process(_delta):
	var positionC2 = get_viewport().get_camera_2d().position
	var mousePosition = get_viewport().get_mouse_position() + Vector2(0,10)
	var tile_pos: Vector2i = local_to_map(mousePosition + positionC2)

	erase_cell(4, prev_tile_pos)
	var tile = get_tile(tile_pos)
	
	if tile != null:
		set_cell(4, tile_pos, 0, Vector2i(0,0),0)
		prev_tile_pos = tile_pos

		if Input.is_action_pressed("LEFT_MOUSE_BUTTON")&&(mode == 0):
			updateTile(tile)
			updateLook(tile)
			updateUnit(tile)
	if mode == 1:
		turnMode(tile)
		

var tile_type_bt = Constants.TileType.NONE
var mode = 0

#Buttons Moved to Bottom
		
func updateTile(tile: Tile):
	tile.resourceLevel = resource_level_bt
	tile.type = tile_type_bt
	

	
func updateLook(tile: Tile):
	
	match [tile.type, tile.resourceLevel]:
		[Constants.TileType.FIELD, 0]:
			tile.zoneControl = 0
			set_cell(Layer.TILE, tile.position, Constants.Asset.FIELD, Vector2i.ZERO, 0)
			erase_cell(Layer.RESOURCE, tile.position)
		[Constants.TileType.FIELD, 1]:
			tile.zoneControl = 0
			set_cell(Layer.TILE, tile.position, Constants.Asset.FIELD, Vector2i.ZERO, 0)
			set_cell(Layer.RESOURCE, tile.position, Constants.Asset.FRUIT, Vector2i.ZERO, 0)
		[Constants.TileType.FIELD, 2]:
			tile.zoneControl = 0
			set_cell(Layer.TILE, tile.position, Constants.Asset.FIELD, Vector2i.ZERO, 0)
			set_cell(Layer.RESOURCE, tile.position, Constants.Asset.CROP, Vector2i.ZERO, 0)
		[Constants.TileType.FOREST, 1]:
			tile.zoneControl = 1
			set_cell(Layer.TILE, tile.position, Constants.Asset.FOREST, Vector2i.ZERO, 0)
			set_cell(Layer.RESOURCE, tile.position, Constants.Asset.ANIMAL, Vector2i.ZERO, 0)
		[Constants.TileType.FOREST, _]:
			tile.zoneControl = 1
			set_cell(Layer.TILE, tile.position, Constants.Asset.FOREST, Vector2i.ZERO, 0)
			erase_cell(Layer.RESOURCE, tile.position)
		[Constants.TileType.MOUNTAIN, 2]:
			tile.zoneControl = 1
			set_cell(Layer.TILE, tile.position, Constants.Asset.MOUNTAIN, Vector2i.ZERO, 0)
			set_cell(Layer.RESOURCE, tile.position, Constants.Asset.METAL, Vector2i.ZERO, 0)
		[Constants.TileType.MOUNTAIN, _]:
			tile.zoneControl = 1
			set_cell(Layer.TILE, tile.position, Constants.Asset.MOUNTAIN, Vector2i.ZERO, 0)
			erase_cell(Layer.RESOURCE, tile.position)
		[Constants.TileType.CLOUD, _]:
			set_cell(Layer.TILE, tile.position, Constants.Asset.CLOUD, Vector2i.ZERO, 0)
			erase_cell(Layer.RESOURCE, tile.position)
		_:
			pass
			

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
			
			
		
func drawPosibleUnitMoves(tile):
	var movement = float(tile.unit.movement)
	var movement_hold = int(movement)	
	#movement = ((movement + .25) - (movement/4)) #I HATE SQUARE # RATIO IS WRONG KILLING MYSELF
	#set_cell(Layer.UNIT_MOVE, tile.position, Constants.Asset.MOVETARGET, Vector2i.ZERO, 0)
	tiles[0][3].zoneControl = 2
	tiles[8][8].zoneControl = 2
	tiles[4][4].zoneControl = 2
	nextTiles2(movement,tile.position)
	movement = movement * 2
	for x in range(((movement) * 3)): 
		for y in range(((movement) * 3)):
			var tileMoveDistClear = tile.position + Vector2i(x,y) - Vector2i(movement,movement)
			if(inBounds(tileMoveDistClear)):
				tiles[tileMoveDistClear.x][tileMoveDistClear.y].movementDist = -1
	
	
	
	#debuging

	"""
	print(movement)
	for x in range(3):
		for y in range(3):
			var vectorHold: Vector2i = tile.position
			vectorHold = vectorHold + Vector2i(x,y) - Vector2i(1,1)
			set_cell(Layer.UNIT_MOVE, tile.position, Constants.Asset.MOVETARGET, Vector2i.ZERO, 0)
			
			
			for i in range(3):
				for j in range(3):
					#var vectorHold2: Vector2i = vectorHold
					var vectorHold2 = vectorHold + Vector2i(i,j) - Vector2i(1,1) 
					if ((vectorHold2.x > -1 && vectorHold2.y > -1) &&  (vectorHold.x > -1 && vectorHold.y > -1) &&
					(vectorHold.x < gridSize && vectorHold.y < gridSize) && (vectorHold2.x < gridSize && vectorHold2.y < gridSize)):
						if (tiles[vectorHold2.x][vectorHold2.y].zoneControl == 2 &&
						tiles[vectorHold.x][vectorHold.y].zoneControl != 2 && tiles[vectorHold.x][vectorHold.y].zoneControl != 1):
							#tiles[vectorHold.x][vectorHold.y].zoneControl = 1
							
							set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.ZOC1MOVETARGET, Vector2i.ZERO, 0)
							set_cell(Layer.UNIT_MOVE, vectorHold2, Constants.Asset.ZOC2MOVETARGET, Vector2i.ZERO, 0) ###commentout later
							print(tiles[vectorHold.x][vectorHold.y].zoneControl)
						elif(tiles[vectorHold.x][vectorHold.y].zoneControl == 1):
							set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.ZOC1MOVETARGET, Vector2i.ZERO, 0)
						
						elif(get_cell_source_id(Layer.UNIT_MOVE,vectorHold)!=14):
							set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.MOVETARGET, Vector2i.ZERO, 0)
							#print("tester")
						
			if vectorHold.x > -1 && vectorHold.y > -1 && vectorHold.x < gridSize && vectorHold.y < gridSize:
				#print(get_cell_source_id(Layer.UNIT_MOVE,vectorHold))
				if (movement > 1 && get_cell_source_id(Layer.UNIT_MOVE,vectorHold)==11):					 #tile set 11 will be MoveTargert 0
					set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.MOVETARGETCHECKED, Vector2i.ZERO, 0)
					print("starter")
					print(vectorHold)
					#movement = movement - 1
					nextTiles2(movement,vectorHold)
				"""
func nextTiles2(movement, vectorHoldPassed):
	#var roadHold = roadPassed

	movement = movement - 1
	set_cell(Layer.UNIT_MOVE, vectorHoldPassed, Constants.Asset.MOVETARGET, Vector2i.ZERO, 0)

	
	for x in range(3):
		for y in range(3):
			var vectorHold: Vector2i = vectorHoldPassed + Vector2i(x,y) - Vector2i(1,1)
			if(inBounds(vectorHold)):
				if(tiles[vectorHold.x][vectorHold.y].zoneControl == 1):
					set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.ZOC1MOVETARGET, Vector2i.ZERO, 0)
				elif(tiles[vectorHold.x][vectorHold.y].zoneControl == 2):
					var tod = 1
				else:
					for i in range(3):
						for j in range(3): 
							var vectorHold2 = vectorHold + Vector2i(i,j) - Vector2i(1,1) 
							if(inBounds(vectorHold2)):
								if(tiles[vectorHold2.x][vectorHold2.y].zoneControl == 2):
									if(movement >= 0):
										set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.ZOC1MOVETARGET, Vector2i.ZERO, 0)
										set_cell(Layer.UNIT_MOVE, vectorHold2, Constants.Asset.ZOC2MOVETARGET, Vector2i.ZERO, 0)
					if(get_cell_source_id(Layer.UNIT_MOVE,vectorHold)!=12 && get_cell_source_id(Layer.UNIT_MOVE,vectorHold)!=13):
						if(movement>tiles[vectorHold.x][vectorHold.y].movementDist):
							#if(tiles[vectorHold.x][vectorHold.y].road == roadHold):
								#match[roadFlip]:
							
								#if(roadFlip == true):
								#	roadFlip = false
								#	movement = movement + 1
								#elif(roadFlip == false):
									#roadFlip = true
								
							tiles[vectorHold.x][vectorHold.y].movementDist = movement
							nextTiles2(movement, vectorHold)
				
				
				
			
func inBounds(vectorPassed):
	if (vectorPassed.x > -1 && vectorPassed.y > -1):
		if(vectorPassed.x < gridSize && vectorPassed.y < gridSize):
			return true
	return false


"""
func nextTiles(movement,vectorHoldPassed):
	
	movement = movement - 1	
	for x in range(3):
		for y in range(3):
			var vectorHold: Vector2i = vectorHoldPassed
			vectorHold = vectorHold + Vector2i(x,y) - Vector2i(1,1)
			
			for i in range(3):
					for j in range(3):
						var vectorHold2: Vector2i = vectorHold
						vectorHold2 = vectorHold2 + Vector2i(i,j) - Vector2i(1,1) 
						
						if ((vectorHold2.x > -1 && vectorHold2.y > -1) &&  (vectorHold.x > -1 && vectorHold.y > -1) &&
						(vectorHold.x < gridSize && vectorHold.y < gridSize) && (vectorHold2.x < gridSize && vectorHold2.y < gridSize)):
							
							if (tiles[vectorHold2.x][vectorHold2.y].zoneControl == 2 &&
							tiles[vectorHold.x][vectorHold.y].zoneControl != 2 && tiles[vectorHold.x][vectorHold.y].zoneControl != 1 ):
								#tiles[vectorHold.x][vectorHold.y].zoneControl = 1
								print("ping0")
								set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.ZOC1MOVETARGET, Vector2i.ZERO, 0)
								set_cell(Layer.UNIT_MOVE, vectorHold2, Constants.Asset.ZOC2MOVETARGET, Vector2i.ZERO, 0) ###commentout later
								#print(tiles[vectorHold.x][vectorHold.y].zoneControl)
								
			if (vectorHold.x > -1 && vectorHold.y > -1) && (vectorHold.x < gridSize && vectorHold.y < gridSize)		:			
				if(tiles[vectorHold.x][vectorHold.y].zoneControl == 1):
					set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.ZOC1MOVETARGET, Vector2i.ZERO, 0)
					print("ping1")
				elif(tiles[vectorHold.x][vectorHold.y].zoneControl != 2 && get_cell_source_id(Layer.UNIT_MOVE,vectorHold)!=14):
					
					set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.MOVETARGET, Vector2i.ZERO, 0)
					print("ping2")
				elif(get_cell_source_id(Layer.UNIT_MOVE,vectorHold)==14):
					print("free")
				else:
					print("ping3")
					set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.MOVETARGET, Vector2i.ZERO, 0)
				#set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.MOVETARGET, Vector2i.ZERO, 0)
			print(vectorHold)
			if vectorHold.x > -1 && vectorHold.y > -1 && vectorHold.x < gridSize && vectorHold.y < gridSize:
				#print(get_cell_source_id(Layer.UNIT_MOVE,vectorHold))
				if (movement > 1 && get_cell_source_id(Layer.UNIT_MOVE,vectorHold)==11): #tile set 11 will be MoveTargert 0
					set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.MOVETARGETCHECKED, Vector2i.ZERO, 0)
					
					var movementpass = movement - 1
					nextTiles(movement,vectorHold)
 """					
							
							
							
							
							
							
						#elif():
							
							#pass
							
						
					
			
	#print(vectorHold)
	#for x in range((movement) * 3): 
	#	for y in range((movement) * 3):
	#		pass
	
	#for x in range((movement) * 3): 
	#	for y in range((movement) * 3):
			
	#		var vectorHold: Vector2i = tile.position

	#		vectorHold = vectorHold + Vector2i(x,y) - Vector2i(movement_hold,movement_hold)

			#print(vectorHold)
	#		if vectorHold.x > -1 && vectorHold.y > -1:
	#			if (vectorHold.x < gridSize && vectorHold.y < gridSize) && !get_cell_tile_data(Layer.UNIT_MOVE, tiles[vectorHold.x][vectorHold.y].position):
					
	#				set_cell(Layer.UNIT_MOVE, vectorHold, Constants.Asset.MOVETARGET, Vector2i.ZERO, 0)
					

#THIS SHITS SO FUCKED ^^^^^^^^^^^^^^^

####################################################################### Buttons
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
			


var unit_type_bt = 0

func _on_warrior_spawn_toggled(toggled_on: bool):
	if toggled_on:
		unit_type_bt = 1 
	else:
		unit_type_bt = 0
	#print(unit)
