extends TileMap


# Called when the node enters the scene tree for the first time.
var gridSize = 11
var Dic = {}

func _ready():
	for x in gridSize:
		for y in gridSize:
			Dic[str(Vector2(x,y))] = {
				"Type": "Field",
				"Position": str(Vector2(x,y))
				
			}
			set_cell(0,Vector2(x,y), 0, Vector2i(0,0),0)
	print(Dic)
var turegate = false	


func _on_play_pressed():
	turegate = true  # Replace with 

	
func _process(delta):
	var tile = local_to_map(get_viewport().get_mouse_position())
	
	for x in gridSize:
		for y in gridSize:
			erase_cell(1, Vector2(x,y))
	
	if Dic.has(str(tile)):
		set_cell(1, tile, 1, Vector2i(0,0),0)
		print(Dic[str(tile)])
		
	if (turegate == true):	
	
		if Dic.has(str(tile)):
			set_cell(0, tile, 2, Vector2i(0,0),0)
			print(Dic[str(tile)])
		
	
