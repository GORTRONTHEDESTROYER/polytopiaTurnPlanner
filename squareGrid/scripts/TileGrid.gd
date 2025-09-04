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
@export var spawnLayer: TileMapLayer
@export var selectionLayer: TileMapLayer

@export var unitHealth: TileMapLayer






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
	#if mode == 0: #delete for performace l8r if better solutions is found

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
			#print(playerSelected.tile_pos2)
			#checkPlayerSelectOverlap()
			if checkPlayerSelectOverlap():
				pass
			elif(unit_type_bt != Constants.UnitType.NONE):
				pass
			elif(tile_type_bt == Constants.TileType.NONE):
				pass
			else: updateTile(tile)
			
			tile.building = building_type_bt
			
			updateLook(tile)
			updateUnit(tile)
	if mode == 1:
		turnMode(tile)
		
		
	

var tile_type_bt = Constants.TileType.NONE
var resource_level_bt = 0
var building_type_bt = Constants.BuildingType.NONE
var unit_type_bt = Constants.UnitType.NONE	

var mode = 0

#Buttons Moved to Bottom
		
func updateTile(tile: Tile):
	var player = playerSelected.selected()

	#if building_type_bt == Constants.BuildingType 
	tile.player = player.player
	tile.resourceLevel = resource_level_bt
	tile.type = tile_type_bt
	
	
func updateLook(tile: Tile):
	
	
	
	match [tile.type, tile.resourceLevel]:
		[Constants.TileType.FIELD, 0]:
			
			tile.typeHeld = tile.type
			tile.zoneControl = 0
			tile.water = false
			
			baseLayer.set_cell(tile.position, 0, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.erase_cell(tile.position)
			
		
			
		[Constants.TileType.FIELD, 1]:
			tile.typeHeld = tile.type
			tile.zoneControl = 0
			tile.water = false
			resourceLayer.erase_cell(tile.position)
			baseLayer.set_cell(tile.position, 1, playerSelected.head[tile.player].tribe, 0)

		[Constants.TileType.FIELD, 2]:
			tile.typeHeld = tile.type
			tile.zoneControl = 0
			tile.water = false
			baseLayer.set_cell(tile.position, 0, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.set_cell( tile.position, 0, Vector2i.ZERO, 0)
		[Constants.TileType.FIELD, 3]:
			tile.typeHeld = tile.type
			tile.zoneControl = 0
			tile.water = false
			baseLayer.set_cell(tile.position, 0, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.set_cell( tile.position, 2, Vector2i(4,0), 0)
		[Constants.TileType.FOREST, 1]:
			tile.typeHeld = tile.type
			tile.zoneControl = 1
			tile.water = false
			resourceLayer.erase_cell(tile.position)
			baseLayer.set_cell(tile.position, 3, playerSelected.head[tile.player].tribe, 0)
			#resourceLayer.set_cell( tile.position, Constants.Asset.ANIMAL, Vector2i.ZERO, 0)
		[Constants.TileType.FOREST, 3]:
			tile.typeHeld = tile.type
			tile.zoneControl = 1
			tile.water = false
			baseLayer.set_cell(tile.position, 2, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.set_cell( tile.position, 2, Vector2i(4,0), 0)
		[Constants.TileType.FOREST, _]:
			tile.typeHeld = tile.type
			tile.zoneControl = 1
			tile.water = false
			baseLayer.set_cell(tile.position, 2, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.erase_cell( tile.position)
		[Constants.TileType.MOUNTAIN, 2]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.water = false
			tile.zoneControl = 1
			baseLayer.set_cell( tile.position, 4, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.set_cell(tile.position, 1, Vector2i.ZERO, 0)
			buildingRoad.erase_cell( tile.position)
		[Constants.TileType.MOUNTAIN, 3]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.water = false
			tile.zoneControl = 1
			baseLayer.set_cell(tile.position, 4, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.set_cell( tile.position, 2, Vector2i(4,0), 0)
		[Constants.TileType.MOUNTAIN, _]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.water = false
			tile.zoneControl = 1
			baseLayer.set_cell(tile.position, 4, playerSelected.head[tile.player].tribe, 0)
			resourceLayer.erase_cell(tile.position)
			buildingRoad.erase_cell( tile.position)
		[Constants.TileType.SHORES, 1]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.water = true
			tile.zoneControl = 3
			baseLayer.set_cell(tile.position, 5, Vector2i(1,0), 0)
			resourceLayer.erase_cell(tile.position)
			buildingRoad.erase_cell( tile.position)
		[Constants.TileType.SHORES, 3]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.water = true
			tile.zoneControl = 1
			baseLayer.set_cell(tile.position, 5, Vector2i(3,0), 0)
			resourceLayer.set_cell(tile.position, 2, Vector2i(0,0), 0)
		[Constants.TileType.SHORES, _]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.water = true
			tile.zoneControl = 3
			baseLayer.set_cell(tile.position, 5, Vector2i(3,0), 0)
			resourceLayer.erase_cell(tile.position)
			buildingRoad.erase_cell( tile.position)
		[Constants.TileType.OCEAN, 1]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.water = true
			tile.zoneControl = 3
			baseLayer.set_cell( tile.position, 5, Vector2i(0,0), 0)
			resourceLayer.erase_cell(tile.position)
			buildingRoad.erase_cell( tile.position)
		[Constants.TileType.OCEAN, 3]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.water = true
			tile.zoneControl = 1
			baseLayer.set_cell( tile.position, 5, Vector2i(2,0), 0)
			resourceLayer.set_cell( tile.position, 2, Vector2i(0,0), 0)
		[Constants.TileType.OCEAN, _]:
			tile.typeHeld = tile.type
			tile.road = false
			tile.water = true
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
		[Constants.BuildingType.DELETE, _]:
			tile.buildingHeld = Constants.BuildingType.NONE
			tile.road = false
			buildingRoad.erase_cell( tile.position)

			buildingLayer.erase_cell( tile.position)
			spawnLayer.erase_cell( tile.position)
			
			if tile.city != null:
				tile.city = null
			
		[Constants.BuildingType.ROAD, Constants.TileType.MOUNTAIN]:
			tile.roadHeld = Constants.BuildingType.NONE
			tile.road = false
			buildingRoad.erase_cell( tile.position)
		[Constants.BuildingType.ROAD, _]:
			tile.roadHeld = Constants.BuildingType.ROAD

			tile.road = true
			buildingRoad.set_cell( tile.position, 0, Vector2i.ZERO, 0)
		[Constants.BuildingType.RUIN, _]:
			tile.buildingHeld = Constants.BuildingType.RUIN

			tile.road = false
			buildingLayer.set_cell( tile.position, 0, Vector2i.ZERO, 0)
		[Constants.BuildingType.VILLAGE, _]:
			tile.buildingHeld = Constants.BuildingType.VILLAGE

			tile.road = true
			buildingLayer.set_cell( tile.position, 1, Vector2i.ZERO, 0)
		[Constants.BuildingType.CITY, _]:
			tile.city = City.new()
		[Constants.BuildingType.RED_SQUARE, _]:
			#tile.buildingHeld = Constants.BuildingType.CITY
			#tile.road = true
			spawnLayer.set_cell( tile.position, 0, Vector2i.ZERO, 0)
			
	if tile.city != null:
		tile.road = true
		buildingLayer.set_cell( tile.position, 4, Vector2i.ZERO, 0)

			
			
			#erase_cell(Layer., tile.position)
			#set_cell(Layer.BUILDING, tile.position, Constants.Asset.ROAD, Vector2i.ZERO, 0)
func updateAllTileLook(fromSaverLoader: bool = false):
	for x in range(gridSize):
		for y in range(gridSize):
			if fromSaverLoader:
				updateLook(tiles[x][y])
				tiles[x][y].building = tiles[x][y].roadHeld
			updateLook(tiles[x][y])
					
					
func updateUnit(tile: Tile):
	if unit_type_bt == Constants.UnitType.DELETE:
		tile.unit = null
		updateUnitLook(tile)

		return
	
	if tile.unit != null:
		updateUnitLook(tile)

		return
	
	
	match unit_type_bt:
		Constants.UnitType.WARRIOR: 
			var player = playerSelected.selected()
			#tile.unit.player = player.player
			
			tile.unit = Unit.new(player.player, 10)
			tile.unit.typeWarrior(Constants.UnitType.WARRIOR)
			
		Constants.UnitType.RIDER: 
			var player = playerSelected.selected()
			tile.unit = Unit.new(player.player, 10)
			tile.unit.typeRider(Constants.UnitType.RIDER)
		Constants.UnitType.ARCHER:
			var player = playerSelected.selected()
			tile.unit = Unit.new(player.player, 10)
			tile.unit.typeArcher(Constants.UnitType.ARCHER)
		Constants.UnitType.DEFENDER:
			var player = playerSelected.selected()
			tile.unit = Unit.new(player.player, 15)
			tile.unit.typeDefender(Constants.UnitType.DEFENDER)
		Constants.UnitType.SWORDSMAN:
			var player = playerSelected.selected()
			tile.unit = Unit.new(player.player, 15)
			tile.unit.typeSwordsman(Constants.UnitType.SWORDSMAN)
		Constants.UnitType.KNIGHT:
			var player = playerSelected.selected()
			tile.unit = Unit.new(player.player, 10)
			tile.unit.typeKnight(Constants.UnitType.KNIGHT)
		Constants.UnitType.CATAPULT:
			var player = playerSelected.selected()
			tile.unit = Unit.new(player.player, 10)
			tile.unit.typeCatapult(Constants.UnitType.CATAPULT)
		Constants.UnitType.MINDBENDER:
			var player = playerSelected.selected()
			tile.unit = Unit.new(player.player, 10)
			tile.unit.typeMindbender(Constants.UnitType.MINDBENDER)
		Constants.UnitType.GIANT:
			var player = playerSelected.selected()
			tile.unit = Unit.new(player.player, 40)
			tile.unit.typeGiant(Constants.UnitType.GIANT)

		_:
			pass
	updateUnitLook(tile)

func updateAllUnitLook():
	for x in range(gridSize):
			for y in range(gridSize):
				updateUnitLook(tiles[x][y])
				
func updateUnitLook(tileW: Tile):
	
	if tileW.unit != null:
		var healthY = (int(tileW.unit.health) -1) / 10
		var healthX = (int(tileW.unit.health) - healthY * 10) - 1
		var defBoost = 0
		tileW.unit.defBonusLogic(tileW,playerSelected.head)
		if tileW.unit.defBonus > 1:
			defBoost = 1
		#var defBoost = tileW.unit.defBoost
		#print(Vector2i(healthY,healthX))
		
		match tileW.unit.type:
			Constants.UnitType.WARRIOR:
				
				#tileW.unit.health
				unitHead.set_cell( tileW.position, 0, playerSelected.head[tileW.unit.player].tribe, 0)
				unitLayer.set_cell( tileW.position, 0, playerSelected.head[tileW.unit.player].color, 0)
				unitHealth.set_cell(tileW.position, defBoost, Vector2i(healthX,healthY), 0)
				
				
			Constants.UnitType.RIDER:
				
				pass
				
				var tempHead = tribeVecToInt(playerSelected.head[tileW.unit.player]) + 1
				print("temphead")
				print(tempHead)
				unitHead.set_cell( tileW.position, 1, playerSelected.head[tileW.unit.player].tribe, 0)
			#	unitLayer.set_cell( tileW.position, playerSelected.TileMapHS.tileSelectPing.ping(playerSelected.head[tileW.unit.player]) + 1, playerSelected.head[tileW.unit.player].color, 0)
				if(tempHead > 15):
					unitLayer.set_cell(tileW.position, 1, 
						Vector2i(((playerSelected.head[tileW.unit.player].color.x + (7 * (tempHead-1)) )-105),
							playerSelected.head[tileW.unit.player].color.y + 3) , 0)
				else:
					unitLayer.set_cell(tileW.position, 1, 
						Vector2i(playerSelected.head[tileW.unit.player].color.x + (7 * (tempHead-1)),
							playerSelected.head[tileW.unit.player].color.y) , 0)

			#	unitHealth.set_cell(tileW.position, 0, Vector2i(healthX,healthY), 0)
				unitHealth.set_cell(tileW.position, defBoost, Vector2i(healthX,healthY), 0)
				
			Constants.UnitType.ARCHER:
				unitHead.set_cell( tileW.position, 0, playerSelected.head[tileW.unit.player].tribe, 0)
				unitLayer.set_cell( tileW.position, 2, playerSelected.head[tileW.unit.player].color, 0)
				unitHealth.set_cell(tileW.position, defBoost, Vector2i(healthX,healthY), 0)
			Constants.UnitType.DEFENDER:
				
				#tileW.unit.health
				unitHead.set_cell( tileW.position, 0, playerSelected.head[tileW.unit.player].tribe, 0)
				unitLayer.set_cell( tileW.position, 3, playerSelected.head[tileW.unit.player].color, 0)
				unitHealth.set_cell(tileW.position, defBoost, Vector2i(healthX,healthY), 0)
				
				
			Constants.UnitType.SWORDSMAN:
				unitHead.set_cell( tileW.position, 0, playerSelected.head[tileW.unit.player].tribe, 0)
				unitLayer.set_cell( tileW.position, 4, playerSelected.head[tileW.unit.player].color, 0)
				unitHealth.set_cell(tileW.position, defBoost, Vector2i(healthX,healthY), 0)
				
			Constants.UnitType.KNIGHT:
				var tempHead = tribeVecToInt(playerSelected.head[tileW.unit.player]) + 1
				unitHead.set_cell( tileW.position, 1, playerSelected.head[tileW.unit.player].tribe, 0)
			#	unitLayer.set_cell( tileW.position, playerSelected.TileMapHS.tileSelectPing.ping(playerSelected.head[tileW.unit.player]) + 1, playerSelected.head[tileW.unit.player].color, 0)
				if(tempHead > 15):
					unitLayer.set_cell(tileW.position, 5, 
						Vector2i(((playerSelected.head[tileW.unit.player].color.x + (7 * (tempHead-1)) )-105),
							playerSelected.head[tileW.unit.player].color.y + 3) , 0)
				else:
					unitLayer.set_cell(tileW.position, 5, 
						Vector2i(playerSelected.head[tileW.unit.player].color.x + (7 * (tempHead-1)),
							playerSelected.head[tileW.unit.player].color.y) , 0)

				unitHealth.set_cell(tileW.position, defBoost, Vector2i(healthX,healthY), 0)
			Constants.UnitType.CATAPULT:
				unitHead.set_cell( tileW.position, 0, playerSelected.head[tileW.unit.player].tribe, 0)
				unitLayer.set_cell( tileW.position, 6, playerSelected.head[tileW.unit.player].color, 0)
				unitHealth.set_cell(tileW.position, defBoost, Vector2i(healthX,healthY), 0)
			Constants.UnitType.MINDBENDER:
				unitHead.set_cell( tileW.position, 0, playerSelected.head[tileW.unit.player].tribe, 0)
				unitLayer.set_cell( tileW.position, 7, playerSelected.head[tileW.unit.player].color, 0)
				unitHealth.set_cell(tileW.position, defBoost, Vector2i(healthX,healthY), 0)
			Constants.UnitType.GIANT:
				unitHead.set_cell( tileW.position, 0, playerSelected.head[tileW.unit.player].tribe, 0)
				unitLayer.set_cell( tileW.position, 8, playerSelected.head[tileW.unit.player].color, 0)
				unitHealth.set_cell(tileW.position, defBoost, Vector2i(healthX,healthY), 0)

			_: 
				pass
	else:
	#	print("erase")
		unitLayer.erase_cell(tileW.position)
		unitHead.erase_cell(tileW.position)
		unitHealth.erase_cell(tileW.position)

		
			
			

func turnMode(tile: Tile):
	if Input.is_action_just_pressed("LEFT_MOUSE_BUTTON"):
		
		
		
		if tile != null && tile.unit != null:
			
			if unitMoveLayer.get_cell_source_id(tile.position) == 2:
				
				combat(state.active_tile, tile)
				unitMoveLayer.clear()
				return
			
			
			if state.active_tile != null:
				state.active_tile.unit.active = false 
				unitMoveLayer.clear()
				
			tile.unit.active = not tile.unit.active
			
			if tile.unit.active:
				state.active_tile = tile
				drawPosibleUnitMoves(tile)
			else: 
				state.active_tile = null
				unitMoveLayer.clear()
			updateUnitLook(tile)
		
		
			
		elif state.active_tile != null && tile != null && unitMoveLayer.get_cell_tile_data(tile.position):
			tile.unit = state.active_tile.unit 
			state.active_tile.unit = null
			updateUnitLook(state.active_tile)
			state.active_tile = null
			tile.unit.active = not tile.unit.active
			updateUnit(tile)
			unitMoveLayer.clear()
			
		elif tile != null && (state.active_tile != null):
			state.active_tile.unit.active = false 
			state.active_tile = null
			unitMoveLayer.clear()
			
func combat(attackerTile, defenderTile):
	#var defenseBonus:float = defenderTile.unit.defBonus
	
	var attackForce = attackerTile.unit.attack * (attackerTile.unit.health / attackerTile.unit.maxHealth)
	var defenseForce = defenderTile.unit.defense * (defenderTile.unit.health  / defenderTile.unit.maxHealth) * defenderTile.unit.defBonus 
	var totalDamage = attackForce + defenseForce 
	var attackResult = round((attackForce / totalDamage) * attackerTile.unit.attack * 4.5) 
	var defenseResult = round((defenseForce / totalDamage) * defenderTile.unit.defense * 4.5)
	
	defenderTile.unit.health = defenderTile.unit.health - attackResult
	
	if(defenderTile.unit.health > 0):
		attackerTile.unit.health = attackerTile.unit.health - defenseResult

	var unit_type_hold:Constants.UnitType = unit_type_bt
	
	print("attack health")
	print(attackerTile.unit.health)
	print(defenderTile.unit.health)
	if attackerTile.unit.health < 1:
		
		unit_type_bt = Constants.UnitType.DELETE
		updateUnit(attackerTile)
		state.active_tile = null
	
	if defenderTile.unit.health < 1:
		unit_type_bt = Constants.UnitType.DELETE
		updateUnit(defenderTile)
		if attackerTile.unit.unitRange == 1:
			unit_type_bt = unit_type_hold
			
			defenderTile.unit = attackerTile.unit 
			attackerTile.unit = null
			updateUnitLook(attackerTile)
			state.active_tile = null
			defenderTile.unit.active = not defenderTile.unit.active
			updateUnit(defenderTile)
			unitMoveLayer.clear()
			pass
		
		
	unit_type_bt = unit_type_hold
	
	updateUnitLook(attackerTile)
	updateUnitLook(defenderTile)
	
	



	
	
	
	
	#
	#
	#unit_type_bt = unit_type_hold
	
	#print("combat")
	#defender = null
	
var looper = 0		
func drawPosibleUnitMoves(tile: Tile):
	var movement = tile.unit.movement
	var unitRange = tile.unit.unitRange
#	print(tile.unit.movement)
	#tiles[1][6].zoneControl = 2
	var flying = false
	var creep = false
	
	
	if(!flying && !creep):
		roadTiles2((movement*2),tile.position)
	
	#roadTiles(movement*3,tile.position)
	tile.spacer = 0
	
	movementRevamp(movement*2, tile.position)
	#print(looper)
	
	movement = movement * 2
	for x in range(((movement) * 3)): 
		for y in range(((movement) * 3)):
			var tileMoveDistClear = tile.position + Vector2i(x,y) - Vector2i(movement,movement)
			if(inBounds(tileMoveDistClear)):
				
				tiles[tileMoveDistClear.x][tileMoveDistClear.y].movementDist = -1
				tiles[tileMoveDistClear.x][tileMoveDistClear.y].spacer = -1
				
	drawRange(unitRange,tile.position)
func drawRange(unitRange,vectorPassed):
	for x in range(unitRange * 2 + 1): 
		for y in range(unitRange * 2 + 1):
			var vectorHold = vectorPassed + Vector2i(x,y) - Vector2i(unitRange,unitRange)
			if inBounds(vectorHold):
				if tiles[vectorHold.x][vectorHold.y].unit != null:
					if !friendlyCheckNoChange(tiles[vectorHold.x][vectorHold.y].unit):
						unitMoveLayer.set_cell(vectorHold, 2, Vector2i.ZERO, 0)
							
func movementRevamp(movement: int, vectorHoldPassed: Vector2i, stupid: bool = true):	
	
	
	var sneak = false
	var creep = false
	var amphibious  = false
	var water = false
	var flying = false
	var cloak = false
	
	
	
	movement = movement - 1 + tiles[vectorHoldPassed.x][vectorHoldPassed.y].spacer

		
	#sets the tile to movable
	unitMoveLayer.set_cell(vectorHoldPassed, 0, Vector2i.ZERO, 0)
	if(movement >= 0):
		#gets access to adjacent tiles
		for x in range(3):
			for y in range(3):
				#holds position of adjacent tile
				var vectorHold: Vector2i = vectorHoldPassed + Vector2i(x,y) - Vector2i(1,1)
				
				
				if(!inBounds(vectorHold)):
					continue  
				if(tiles[vectorHold.x][vectorHold.y].unit != null):
					var zoneHold = tiles[vectorHold.x][vectorHold.y].zoneControl
					if (!friendlyCheck(tiles[vectorHold.x][vectorHold.y].unit, vectorHold) && cloak == false):
						tiles[vectorHold.x][vectorHold.y].zoneControl = zoneHold
						continue
					tiles[vectorHold.x][vectorHold.y].zoneControl = zoneHold
						
					  
				#water movement
				if((tiles[vectorHold.x][vectorHold.y].water == true) && (!amphibious && !water && !flying) && tiles[vectorHold.x][vectorHold.y].zoneControl !=1):
					continue
				if(tiles[vectorHold.x][vectorHold.y].water == false) && water:
					unitMoveLayer.set_cell( vectorHold, 3, Vector2i.ZERO, 0)
					continue
				if(tiles[vectorHold.x][vectorHold.y].water == true) && amphibious:
					unitMoveLayer.set_cell( vectorHold, Constants.Asset.MOVETARGET, Vector2i.ZERO, 0)
					continue
				
				if(tiles[vectorHold.x][vectorHold.y].zoneControl == 1) && (!creep && !flying):
					roughTerrain(vectorHold,vectorHoldPassed,movement,stupid)
					continue  
				if(sneak == false):
					zoneOfControl(vectorHold)
					
					
				if(unitMoveLayer.get_cell_source_id(vectorHold)!=1):
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
			if(inBounds(vectorHold2) ):
				var zoneHold = tiles[vectorHold2.x][vectorHold2.y].zoneControl
				if tiles[vectorHold2.x][vectorHold2.y].unit != null:
					friendlyCheck(tiles[vectorHold2.x][vectorHold2.y].unit, vectorHold2)
				if(tiles[vectorHold2.x][vectorHold2.y].zoneControl == 2):
					unitMoveLayer.set_cell( vectorHold, 1, Vector2i.ZERO, 0)
				#	unitMoveLayer.set_cell( vectorHold2, 2, Vector2i.ZERO, 0)
					tiles[vectorHold2.x][vectorHold2.y].zoneControl = zoneHold


func friendlyCheck(unitObject, vectorHold2):
	if state.active_tile.unit.player == unitObject.player:
	#	print(vectorHold2)
		return true
	for x in playerSelected.head[state.active_tile.unit.player].diplo:
		if playerSelected.head[state.active_tile.unit.player].diplo[x-1] == unitObject.player:
			#print(vectorHold2)
			return true
	tiles[vectorHold2.x][vectorHold2.y].zoneControl = 2 
	return false	
		
func friendlyCheckNoChange(unitObject):
	if state.active_tile.unit.player == unitObject.player:
	#	print(vectorHold2)
		return true
	for x in playerSelected.head[state.active_tile.unit.player].diplo:
		if playerSelected.head[state.active_tile.unit.player].diplo[x-1] == unitObject.player:
			#print(vectorHold2)
			return true
	#tiles[vectorHold2.x][vectorHold2.y].zoneControl = 2 
	return false	
					
					
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
								unitMoveLayer.set_cell( vectorHold2, 2, Vector2i.ZERO, 0)
								zonepass = false
				#terminal tiles
				if(zonepass):
					movementRevamp(movement-4, vectorHold)
			#	nextTiles2(movement-4, vectorHold)
			unitMoveLayer.set_cell( vectorHold, 1, Vector2i.ZERO, 0)

func roadRec(vectorHold,vectorHoldPassed,movement,stupid):
	if(tiles[vectorHold.x][vectorHold.y].spacer == -1 && tiles[vectorHoldPassed.x][vectorHoldPassed.y].spacer == -1):
		movementRevamp(movement+1, vectorHold)
	elif(tiles[vectorHold.x][vectorHold.y].movementDistSource == tiles[vectorHoldPassed.x][vectorHoldPassed.y].movementDistSource):
		if(stupid == true):
			movementRevamp(movement+1, vectorHold, false)


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




func checkPlayerSelectOverlap():
	if !playerSelected.hid && (playerSelected.tile_pos2.x > -7 && playerSelected.tile_pos2.y < 7 && playerSelected.tile_pos2.x < 0 && playerSelected.tile_pos2.y > 0):
		return true
	return false
	
func tribeVecToInt(head):
	var tribeS:int = 0
	var colorS:int
	
	match[head.tribe]:
		[Vector2i(0,0)]:
			tribeS = 0
		[Vector2i(1,0)]:
			tribeS = 1
		[Vector2i(2,0)]:
			tribeS = 2
		[Vector2i(3,0)]:
			tribeS = 3
		[Vector2i(4,0)]:
			tribeS = 4
		[Vector2i(5,0)]:
			tribeS = 5
		[Vector2i(6,0)]:
			tribeS = 6
		[Vector2i(1,1)]:
			tribeS = 7
		[Vector2i(2,1)]:
			tribeS = 8
		[Vector2i(3,1)]:
			tribeS = 9
		[Vector2i(4,1)]:
			tribeS = 10
		[Vector2i(5,1)]:
			tribeS = 11
		[Vector2i(6,1)]:
			tribeS = 12
		[Vector2i(0,2)]:
			tribeS = 13
		[Vector2i(1,2)]:
			tribeS = 14
		[Vector2i(2,2)]:
			tribeS = 15
	return tribeS
	'''
	match[head.color]:
		[Vector2i(0,0)]:
			colorS = 0
		[Vector2i(1,0)]:
			colorS = 1
		[Vector2i(2,0)]:
			colorS = 2
		[Vector2i(3,0)]:
			colorS = 3
		[Vector2i(4,0)]:
			colorS = 4
		[Vector2i(5,0)]:
			colorS = 5
		[Vector2i(6,0)]:
			colorS = 6
		[Vector2i(1,1)]:
			colorS = 7
		[Vector2i(2,1)]:
			colorS = 8
		[Vector2i(3,1)]:
			colorS = 9
		[Vector2i(4,1)]:
			colorS = 10
		[Vector2i(5,1)]:
			colorS = 11
		[Vector2i(6,1)]:
			colorS = 12
		[Vector2i(0,2)]:
			colorS = 13
		[Vector2i(1,2)]:
			colorS = 14
		[Vector2i(2,2)]:
			colorS = 15
	'''
