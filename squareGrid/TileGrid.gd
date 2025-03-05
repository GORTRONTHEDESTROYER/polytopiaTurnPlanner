extends TileMap

enum tileType {FIELD, FOREST, MOUNTAIN}
enum {IMP}

const Camera2d = preload("res://Camera2D.gd")

var gridSize = 22
var Dic = {}
var Tile = load("res://Tile.gd")

func _ready():
	var myTile = Tile.new(tileType.FIELD, IMP, Vector2i(0,0))
	print(myTile)
	for x in gridSize:
		for y in gridSize:
			
			Dic[str(Vector2(x,y))] = Tile.new(tileType.FIELD, IMP, Vector2i(x,y))
			set_cell(0,Dic[str(Vector2(x,y))].pos, 1, Vector2i(0,0),0)

func _process(_delta):
	var positionC2 = get_viewport().get_camera_2d().position
	var mouseposition = get_viewport().get_mouse_position() + Vector2(0,10)
	var tile = local_to_map(mouseposition + positionC2)
	for x in gridSize:
		for y in gridSize:
			erase_cell(2, Vector2(x,y))
	
	if Dic.has(str(tile)):
		set_cell(2, tile, 0, Vector2i(0,0),0)
		
	mousepressed(tile)
	
var tile_type_bt = ""
	
func _on_mountain_button_pressed():
	tile_type_bt = "mountain_bt" 

func _on_field_button_pressed():
	tile_type_bt = "field_bt"
	
func _on_forest_button_pressed():
	tile_type_bt = "forest_bt" 
	
func _on_clear_tile_pressed():
	tile_type_bt = ""  # Replace with function body.
	
func tile_clear():
	tile_type_bt = ""

	
var resource_level_bt = 0
var res_1_check = false
func _on_teir_one_pressed():
	res_1_check = !res_1_check
	if (res_1_check):
		resource_level_bt = 1 
	else:
		resource_level_bt = 0
	
func res_1_clear():
	resource_level_bt = 0

func mousepressed(tile):
	if Input.is_action_pressed("LEFT_MOUSE_BUTTON")&&Dic.has(str(tile)):
		match tile_type_bt: 
			"field_bt":
				if(Dic[str(tile)].res == 1):
					Dic[str(tile)].tileType(0)
					resource_convert(Dic[str(tile)].type,tile)
				else:	
					set_cell(0, tile, 1, Vector2i(0,0),0)
					Dic[str(tile)] = Tile.new(tileType.FIELD, IMP, tile)
			"forest_bt":
				if(Dic[str(tile)].res == 1):
					Dic[str(tile)].tileType(1)
					resource_convert(Dic[str(tile)].type,tile)
				else:
					set_cell(0, tile, 2, Vector2i(0,0),0)
					Dic[str(tile)] = Tile.new(tileType.FOREST, IMP, tile)

			"mountain_bt":
				set_cell(0, tile, 3, Vector2i(0,0),0)
				Dic[str(tile)] = Tile.new(tileType.MOUNTAIN, IMP, tile)
				erase_cell(1, tile)
				
		match resource_level_bt:
			1:
				Dic[str(tile)].tileResource(1)
				if(Dic[str(tile)].type == 0):
					set_cell(1, tile, 4, Vector2i(0,0),0)
				elif(Dic[str(tile)].type == 1):
					set_cell(1, tile, 5, Vector2i(0,0),0)
				elif (Dic[str(tile)].res != 2):
					Dic[str(tile)].tileResource(0)
					erase_cell(1, tile)
			2:
				pass
			_:
				pass
				
func resource_convert(type,tile):
	#print(typeP)
	#print(Dic[str(tile)].res)
	if (Dic[str(tile)].res == 1):
		match type:
			0:
				set_cell(1, tile, 4, Vector2i(0,0),0) 
				set_cell(0, tile, 1, Vector2i(0,0),0) 
			1:
				set_cell(1, tile, 5, Vector2i(0,0),0) 
				set_cell(0, tile, 2, Vector2i(0,0),0) 
			_:
				pass
	




