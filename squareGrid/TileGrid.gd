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
			set_cell(0,Dic[str(Vector2(x,y))].pos, 0, Vector2i(0,0),0)
			
var tile_type_bt = ""

func _process(_delta):
	var positionC2 = get_viewport().get_camera_2d().position
	var mouseposition = get_viewport().get_mouse_position() + Vector2(0,10)
	var tile = local_to_map(mouseposition + positionC2)
	for x in gridSize:
		for y in gridSize:
			erase_cell(1, Vector2(x,y))
	
	if Dic.has(str(tile)):
		set_cell(1, tile, 1, Vector2i(0,0),0)
		
	mousepressed(tile)
	
func _on_mountain_button_pressed():
	tile_type_bt = "mountain_bt" 

func _on_field_button_pressed():
	tile_type_bt = "field_bt"
	
func _on_forest_button_pressed():
	tile_type_bt = "forest_bt" 
	
func button_clear():
	tile_type_bt = ""
	
func mousepressed(tile):
	
	match tile_type_bt: 
		"field_bt":
			if Input.is_action_pressed("LEFT_MOUSE_BUTTON"):
				if Dic.has(str(tile)):
					set_cell(0, tile, 0, Vector2i(0,0),0)
					Dic[str(tile)] = Tile.new(tileType.FIELD, IMP, tile)
		"forest_bt":
			if Input.is_action_pressed("LEFT_MOUSE_BUTTON"):
				if Dic.has(str(tile)):
					set_cell(0, tile, 2, Vector2i(0,0),0)
					Dic[str(tile)] = Tile.new(tileType.FOREST, IMP, tile)
			
		"mountain_bt":
			if Input.is_action_pressed("LEFT_MOUSE_BUTTON"):
				if Dic.has(str(tile)):
					set_cell(0, tile, 3, Vector2i(0,0),0)
					Dic[str(tile)] = Tile.new(tileType.MOUNTAIN, IMP, tile)
