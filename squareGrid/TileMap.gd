extends TileMap

enum tileType {FIELD, FOREST, MOUNTAIN}
enum {IMP}


const Camera2d = preload("res://Camera2D.gd")
# Called when the node enters the scene tree for the first time.
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
			
var forest_bt = false
var mountain_bt = false
var field_bt = false


func _on_forest_button_pressed():
	button_clear()
	forest_bt = true  # Replace with function body.

func _on_mountain_button_pressed():
	button_clear()
	mountain_bt = true # Replace with function body.

func _on_field_button_pressed():
	button_clear() # Replace with function body.
	field_bt = true
	
func button_clear():
	forest_bt = false
	mountain_bt = false
	field_bt = false # Replace with function body.
	
	
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
	
func mousepressed(tile):
	

	if (forest_bt == true ):	
		if Input.is_action_pressed("LEFT_MOUSE_BUTTON"):
			if Dic.has(str(tile)):
				set_cell(0, tile, 2, Vector2i(0,0),0)
				Dic[str(tile)] = {
					"Type": tileType.FOREST,
					"Position": tile,
					"Tribe": IMP
				}
	if (mountain_bt == true ):	
		if Input.is_action_pressed("LEFT_MOUSE_BUTTON"):
			if Dic.has(str(tile)):
				set_cell(0, tile, 3, Vector2i(0,0),0)
				Dic[str(tile)] = {
					"Type": tileType.MOUNTAIN,
					"Position": tile,
					"Tribe": IMP
				}
	if (field_bt == true ):	
		if Input.is_action_pressed("LEFT_MOUSE_BUTTON"):
			if Dic.has(str(tile)):
				set_cell(0, tile, 0, Vector2i(0,0),0)
				Dic[str(tile)] = {
					"Type": tileType.FIELD,
					"Position": tile,
					"Tribe": IMP
				}
				
				
				



