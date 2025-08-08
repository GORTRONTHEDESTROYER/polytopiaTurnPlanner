extends Node2D
@export var mainSelect: AnimatedSprite2D
@export var tilesPlains: Control
@export var tilesRoughTerrain: Control
@export var tilesWater: Control
@export var tilesCymanti: Control
@export var tilesNatGen: Control

@export var TileMapMain: Node2D

#@export var tribeSelectData: NinePatchRect

@export var background: TileMapLayer
@export var selection: TileMapLayer
var hid = false
var switch = 0

#@export var mainSelect: AnimatedSprite2D
func _ready():
	setup()
	hidFlip()
	#pass

func setup():
	
	tilesWater.shoreNull.frame = 3
	tilesWater.shoreFish.frame = 1
	tilesWater.oceanNull.frame = 2
	tilesWater.oceanFish.frame = 0
	
	tilesCymanti.shoreAlgae.frame = 3
	tilesCymanti.oceanAlgae.frame = 2
	
func hidFlip():
	if hid:
		hid = !hid
		tilesPlains.visible = true
		tilesPlains.visible = true
		tilesRoughTerrain.visible = true
		tilesWater.visible = true
		tilesCymanti.visible = true
		tilesNatGen.visible = true
	else:
		hid = !hid
		tilesPlains.visible = false
		tilesRoughTerrain.visible = false
		tilesWater.visible = false
		tilesCymanti.visible = false
		tilesNatGen.visible = false

func _process(_delta):
	#var positionC3 = get_viewport().position
	#var mousePosition2 = get_viewport().get_mouse_position()
	#var tile_pos: Vector2i = local_to_map(mousePosition + positionC2)
	var tile_pos2: Vector2i = Vector2i((selection.local_to_map(get_global_mouse_position()).x) / 5,(selection.local_to_map(get_global_mouse_position()).y / 5) )
	#tile_pos2 = tile_pos2 - Vector2i(14, 0)
	#print(tile_pos2)
	selection.clear()
	get_tile(tile_pos2)
	
	#tile_type_bt
	
	#resource_level_bt
	
	if Input.is_action_just_released("LEFT_MOUSE_BUTTON"):
		print(tile_pos2)
		
		match [tile_pos2]:
				[Vector2i(3,0)]:
					print(1)
					return
				[Vector2i(4,0)]:
					print(2)
					return
				[Vector2i(4,1)]:
					print(3)
					return
				[Vector2i(4,2)]:
					print(4)
					return
		if hid:
			match[tile_pos2]:
				[Vector2i(0,0)]:
					hidFlip()
			return
		if(!(!hid && (tile_pos2.x > -1 && tile_pos2.y < 6 && tile_pos2.x < 5 && tile_pos2.y > -1))):
			return
			#return
			
		if switch != 0:
			background.clear()
		TileMapMain.building_type_bt = 0
		match[tile_pos2]:
			[Vector2i(0,0)]:
				hidFlip()
			[Vector2i(0,1)]:
				if switch == 1:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 1
				TileMapMain.resource_level_bt = 0

				TileMapMain.tile_type_bt = Constants.TileType.FIELD
			[Vector2i(1,1)]:
				if switch == 2:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 2
				TileMapMain.resource_level_bt = 1
				TileMapMain.tile_type_bt = Constants.TileType.FIELD
			[Vector2i(2,1)]:
				if switch == 3:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 3
				TileMapMain.resource_level_bt = 2
				TileMapMain.tile_type_bt = Constants.TileType.FIELD
			[Vector2i(3,1)]:
				pass
			[Vector2i(0,2)]:
				if switch == 4:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 4
				TileMapMain.resource_level_bt = 0
				TileMapMain.tile_type_bt = Constants.TileType.FOREST
			[Vector2i(1,2)]:
				if switch == 5:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 5
				TileMapMain.resource_level_bt = 1
				TileMapMain.tile_type_bt = Constants.TileType.FOREST
				
			[Vector2i(2,2)]:
				if switch == 6:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 6
				TileMapMain.resource_level_bt = 0
				TileMapMain.tile_type_bt = Constants.TileType.MOUNTAIN
			[Vector2i(3,2)]:
				if switch == 7:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 7
				TileMapMain.resource_level_bt = 2
				TileMapMain.tile_type_bt = Constants.TileType.MOUNTAIN
			[Vector2i(0,3)]:
				if switch == 8:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 8
				TileMapMain.resource_level_bt = 0
				TileMapMain.tile_type_bt = Constants.TileType.SHORES
			[Vector2i(1,3)]:
				if switch == 9:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 9
				TileMapMain.resource_level_bt = 1
				TileMapMain.tile_type_bt = Constants.TileType.SHORES
			[Vector2i(2,3)]:
				if switch == 10:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 10
				TileMapMain.resource_level_bt = 0
				TileMapMain.tile_type_bt = Constants.TileType.OCEAN
			[Vector2i(3,3)]:
				if switch == 11:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 11
				TileMapMain.resource_level_bt = 1
				TileMapMain.tile_type_bt = Constants.TileType.OCEAN
			[Vector2i(4,3)]:
				pass
				#CymantiRes
			[Vector2i(0,4)]:
				if switch == 12:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 12
				TileMapMain.resource_level_bt = 3
				TileMapMain.tile_type_bt = Constants.TileType.FIELD
			[Vector2i(1,4)]:
				if switch == 13:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 13
				TileMapMain.resource_level_bt = 3
				TileMapMain.tile_type_bt = Constants.TileType.FOREST
			[Vector2i(2,4)]:
				if switch == 14:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 14
				TileMapMain.resource_level_bt = 3
				TileMapMain.tile_type_bt = Constants.TileType.MOUNTAIN
			[Vector2i(3,4)]:
				if switch == 15:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 15
				TileMapMain.resource_level_bt = 3
				TileMapMain.tile_type_bt = Constants.TileType.SHORES
			[Vector2i(4,4)]:
				if switch == 16:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 16
				TileMapMain.resource_level_bt = 3
				TileMapMain.tile_type_bt = Constants.TileType.OCEAN
			[Vector2i(0,5)]:
				if switch == 17:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 17
				TileMapMain.resource_level_bt = 0
				TileMapMain.tile_type_bt = Constants.TileType.CLOUD
			[Vector2i(1,5)]:
				if switch == 18:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 18
				TileMapMain.resource_level_bt = 0
				TileMapMain.building_type_bt = Constants.BuildingType.VILLAGE
				TileMapMain.tile_type_bt = Constants.TileType.NONE
			[Vector2i(2,5)]:
				if switch == 19:
					TileMapMain.tile_type_bt = Constants.TileType.NONE
					TileMapMain.resource_level_bt = 0
					switch = 0
					return
				background.set_cell(Vector2i(tile_pos2.x,tile_pos2.y + 1), 0, Constants.Tribe.KIC,0)
				switch = 19
				TileMapMain.resource_level_bt = 0
				TileMapMain.tile_type_bt = Constants.TileType.NONE
				TileMapMain.building_type_bt = Constants.BuildingType.RUIN
			[Vector2i(3,5)]:
				pass
			[Vector2i(4,5)]:
				pass
			
			[_]:
				pass



func get_tile(pos: Vector2i) -> void:
	#skips blank cells
	match [pos]:
		[Vector2i(3,0)]:
			return
		[Vector2i(4,0)]:
			return
		[Vector2i(4,1)]:
			return
		[Vector2i(4,2)]:
			return
	match [pos]:
		[Vector2i(0,0)]:
			selection.set_cell(Vector2i(pos.x,pos.y + 1), 0, Constants.Tribe.VEN,0)
		[Vector2i(1,0)]:
			selection.set_cell(Vector2i(pos.x,pos.y + 1), 0, Constants.Tribe.VEN,0)
		[Vector2i(2,0)]:
			selection.set_cell(Vector2i(pos.x,pos.y + 1), 0, Constants.Tribe.VEN,0)
	if !hid && (pos.x > -1 && pos.y < 6 && pos.x < 5 && pos.y > -1):
		selection.set_cell(Vector2i(pos.x,pos.y + 1), 0, Constants.Tribe.VEN,0)
		
func ping(head):
	var tribeS = 0
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
			
			
	mainSelect.frame = tribeS
	
	tilesPlains.plainsNull.frame = tribeS
	tilesPlains.plainsFruit.frame = tribeS
	tilesPlains.plainsFarm.frame = tribeS
	#tilesWater..frame = 0
	
	tilesRoughTerrain.forestNull.frame = tribeS
	tilesRoughTerrain.forestAnimal.frame = tribeS
	tilesRoughTerrain.mountainNull.frame = tribeS
	tilesRoughTerrain.mountainMetal.frame = tribeS
	
	tilesCymanti.plainsFungi.frame = tribeS
	tilesCymanti.forestFungi.frame = tribeS
	tilesCymanti.mountainFungi.frame = tribeS
	#tilesCymanti.shoreAlgae.frame = tribeS
	#tilesCymanti.oceanAlgae.frame = tribeS
	
	#tilesWater.shoreNull.frame = 3
	#tilesWater.shoreFish.frame = 1
	#tilesWater.oceanNull.frame = 2
	#tilesWater.oceanFish.frame = 0
	
