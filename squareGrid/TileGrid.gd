extends TileMap

const Camera2d = preload("res://Camera2D.gd")

enum Layer {TILE, RESOURCE, SELECTION}

var gridSize = 22
var Dic = {}
var tiles: Array[Array] = []

func get_tile(pos: Vector2i) -> Tile:
	if pos.x < 0 or pos.y < 0 or pos.x >= gridSize or pos.y >= gridSize:
		return null
	return tiles[pos.x][pos.y]

func _ready():
	for x in range(gridSize):
		tiles.append([])
		for y in range(gridSize):
			tiles[x].append(Tile.new(Constants.TileType.FIELD, Constants.Tribe.IMP, Vector2i(x,y)))
			Dic[str(Vector2i(x,y))] = Tile.new(Constants.TileType.FIELD, Constants.Tribe.IMP, Vector2i(x,y))
			set_cell(0, Vector2i(x,y), 1, Vector2i(0,0), 0)

var prev_tile_pos: Vector2i = Vector2i(0, 0)

func _process(_delta):
	var positionC2 = get_viewport().get_camera_2d().position
	var mousePosition = get_viewport().get_mouse_position() + Vector2(0,10)
	var tile_pos: Vector2i = local_to_map(mousePosition + positionC2)
	
	erase_cell(2, prev_tile_pos)
	var tile = get_tile(tile_pos)
	if tile != null:
		set_cell(2, tile_pos, 0, Vector2i(0,0),0)
		prev_tile_pos = tile_pos
		if Input.is_action_pressed("LEFT_MOUSE_BUTTON"):
			mousepressed(tile)
			updateLook(tile)

var tile_type_bt = ""
	
func _on_mountain_button_pressed():
	tile_type_bt = Constants.TileType.MOUNTAIN

func _on_field_button_pressed():
	tile_type_bt = Constants.TileType.FIELD
	
func _on_forest_button_pressed():
	tile_type_bt = Constants.TileType.FOREST
	
func _on_clear_tile_pressed():
	tile_type_bt = ""  # Replace with function body.
	
func tile_clear():
	tile_type_bt = ""


var resource_level_bt = 0
func _on_teir_one_toggled(toggled_on: bool):
	if toggled_on:
		resource_level_bt = 1 
	else:
		resource_level_bt = 0

func res_1_clear():
	resource_level_bt = 0

func mousepressed(tile: Tile):
	tile.resourceLevel = resource_level_bt
	tile.type = tile_type_bt

func updateLook(tile: Tile):
	match [tile.type, tile.resourceLevel]:
		[Constants.TileType.FIELD, 0]:
			set_cell(Layer.TILE, tile.position, Constants.Asset.FIELD, Vector2i.ZERO, 0)
			erase_cell(Layer.RESOURCE, tile.position)
		[Constants.TileType.FIELD, 1]:
			set_cell(Layer.TILE, tile.position, Constants.Asset.FIELD, Vector2i.ZERO, 0)
			set_cell(Layer.RESOURCE, tile.position, Constants.Asset.FRUIT, Vector2i.ZERO, 0)
		[Constants.TileType.FOREST, 0]:
			set_cell(Layer.TILE, tile.position, Constants.Asset.FOREST, Vector2i.ZERO, 0)
			erase_cell(Layer.RESOURCE, tile.position)
		[Constants.TileType.FOREST, 1]:
			set_cell(Layer.TILE, tile.position, Constants.Asset.FOREST, Vector2i.ZERO, 0)
			set_cell(Layer.RESOURCE, tile.position, Constants.Asset.ANIMAL, Vector2i.ZERO, 0)
		_:
			set_cell(Layer.TILE, tile.position, Constants.Asset.MOUNTAIN, Vector2i.ZERO, 0)
			erase_cell(Layer.RESOURCE, tile.position)

func resource_convert(tile: Tile):
	#print(typeP)
	#print(tile.resource_level)
	if tile.resourceLevel == 0:
		match tile.type:
			Constants.TileType.FIELD:
				set_cell(Layer.RESOURCE, tile.position, Constants.Asset.FRUIT, Vector2i(0,0), 0) 
				set_cell(0, tile.position, Constants.Asset.FIELD, Vector2i(0,0), 0) 
			#Constants.TileType.FOREST:
				#set_cell(1, tile.position, Constants.Asset.ANIMAL, Vector2i(0,0), 0) 
				#set_cell(0, tile.position, Constants.Asset.FOREST, Vector2i(0,0), 0) 
			_:
				pass
