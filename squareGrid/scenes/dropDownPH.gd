extends NinePatchRect
var players : int = Global.players
@onready var TileMapHS = $TileMapSelect
var head: Array = []
var hid = true

@export var save : Sprite2D
#var PH = PlayerHead.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	#TileMapHS.start()
	
	#PlayerHead.start()
	#print("i")



	for i in players:
		#print(i)
		head.append(PlayerHead.new(i,Constants.Tribe.XIN,Constants.Tribe.XIN, i))
		#TileMapHS.updateTribe(head[i])
		#head[i].printer()
	TileMapHS.update(head[0])
		
	#head[3].tribe = Vector2i(1,0)
	
	#head[3].color = Constants.Tribe.CYM
	#head[4].color = Constants.Tribe.VEN
	#head[2].color = Constants.Tribe.IMP
	#head[1].color = Constants.Tribe.HOO
	
	#print(head[1].location)
	#for i in players:
		#TileMapHS.update(head[i])
		
	#TileMapHS.updateTribe(head[3])
	#generateAltHeads()
	#generateAltColors()

func loadReady():
	players = Global.players
	#print("readyCleared")
	for i in players:
	#	print(i)
		head.append(PlayerHead.new(i,Constants.Tribe.XIN,Constants.Tribe.XIN, i))
	#TileMapHS.start()
	#pass # Replace with function body.
var tile_pos2: Vector2i 
#var prev_tile_pos: Vector2i = Vector2i(0, 0)
var diplo = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#var positionC3 = get_viewport().position
	#var mousePosition2 = get_viewport().get_mouse_position()
	#var tile_pos: Vector2i = local_to_map(mousePosition + positionC2)
	tile_pos2 = Vector2i((TileMapHS.local_to_map(get_global_mouse_position()).x + 3) / 5,(TileMapHS.local_to_map(get_global_mouse_position()).y / 5) )
	tile_pos2 = tile_pos2 - Vector2i(14, 0)
	#print(tile_pos2)
	TileMapHS.clear_layer(3)
	get_tile(tile_pos2)
	#prev_tile_pos = tile_pos2
	
	if Input.is_action_just_released("LEFT_MOUSE_BUTTON"):
		#tribe and color switcher
		
		if(tile_pos2.x == -3 && tile_pos2.y == 0):
			if(TileMapHS.unitBoard.mode == 1):
				TileMapHS.unitBoard.mode = 0
				TileMapHS.erase_cell(0,Vector2i(-3,1))
				return
			TileMapHS.unitBoard.mode = 1
			TileMapHS.set_cell(0, Vector2i(-3,1), 0, Constants.Tribe.KIC,0)
			return
		if(tile_pos2.x == -2 && tile_pos2.y == 0):
			save.save_game()
			return
		if(tile_pos2.x == -1 && tile_pos2.y == 0):
			save.load_game()
			return
		
		var breaker = false
		if (tile_pos2.x > -7 && tile_pos2.y < 7 && tile_pos2.x < 0 && tile_pos2.y > 0):
			if(tile_pos2.x == -2 && tile_pos2.y == 3):
				diplo = !diplo
				if diplo:
					TileMapHS.set_cell(0, Vector2i(-2,4), 0, Constants.Tribe.KIC,0)
				else:
					TileMapHS.erase_cell(0,Vector2i(-2,4))
			elif TileMapHS.get_cell_tile_data(2,Vector2i(tile_pos2.x,1+tile_pos2.y)) != null:
				for i in players:
					if head[i].location == 0:
						head[i].tribe = TileMapHS.get_cell_atlas_coords(2,Vector2i(tile_pos2.x,1+tile_pos2.y))
						TileMapHS.update(head[i])
						
						break
			elif TileMapHS.get_cell_tile_data(0,Vector2i(tile_pos2.x,1+tile_pos2.y)) != null:
				for i in players:
					if head[i].location == 0:
						head[i].color = TileMapHS.get_cell_atlas_coords(0,Vector2i(tile_pos2.x,1+tile_pos2.y))
						TileMapHS.update(head[i])
						break
		#hider / shower switch
		elif tile_pos2.x < 0 or tile_pos2.y < 0 or tile_pos2.x >= 1 or tile_pos2.y >= players:
			pass
		elif (tile_pos2.y == 0):
			if hid == false:
				TileMapHS.hideUnselected(players)
				diplo = false
			else: 
				for i in players:
					if head[i].location == 0:
						showDiplo(head[i])
					TileMapHS.update2(head[i]) ####
					generateAltHeads()
					generateAltColors()
			hid = !hid
		elif !hid:
			for i in players:
				if breaker == true:
					break
				if head[i].location == tile_pos2.y:
					for j in players:
						if head[j].location == 0:
							
							if diplo:
								if head[j].diplo.has(int(head[i].player)):
									head[j].diplo.erase(int(head[i].player))
									head[i].diplo.erase(int(head[j].player))
									showDiplo(head[j])
								else:
									head[j].diplo.append(int(head[i].player)) 
									head[i].diplo.append(int(head[j].player)) 
									showDiplo(head[j])
									
							else:
								head[j].location = tile_pos2.y
								#print(head[j].location)
								head[i].location = 0
								breaker = true
								TileMapHS.update(head[i])
								TileMapHS.update(head[j])
								TileMapHS.tileSelectPing.ping(head[i])
								showDiplo(head[i])
								break
							
						
		#for i in players:
		#	TileMapHS.update(head[i])
							
					
			
				
			#TileMapHS.set_cell(2, Vector2i(0,0), 2, head[pos.y].color,0)

func get_tile(pos: Vector2i) -> void:
	
	if pos.x < 0 && pos.y == 0 && pos.x > -4:
		TileMapHS.set_cell(3, Vector2i(pos.x,pos.y + 1), 2, Constants.Tribe.VEN,0)
	
	if pos.x < 0 or pos.y < 0 or pos.x >= 1 or pos.y >= players:
		pass
	else:
		for i in players:
			if head[i].location == pos.y:
				if head[i].location == 0:
					TileMapHS.set_cell(3, Vector2i(pos.x,pos.y + 1), 2, head[i].color,0)
				elif(!hid):
					TileMapHS.set_cell(3, Vector2i(pos.x,pos.y + 1), 2, head[i].color,0)
				return
	if !hid && (pos.x > -7 && pos.y < 7 && pos.x < 0 && pos.y > 0):
		TileMapHS.set_cell(3, Vector2i(pos.x,pos.y + 1), 2, Constants.Tribe.VEN,0)

	#return void

func showDiplo(headP):
	for i in players:
		TileMapHS.erase_cell(2,Vector2i(0,1+i))

#	print("diplo")
#	print( headP.diplo)
	for i in headP.diplo.size():
	#	print("i2")
	#	print(i)
	#	print(headP.diplo[i - 1])
	#	print(head[1].location)
		#print(head[2].location)
		#print( head[(head.diplo[i-1])-1].location)
		TileMapHS.set_cell(2,Vector2i(0,1 + head[headP.diplo[i-1]].location),1,Vector2i(4,2),0)


func generateAltHeads():
	
	TileMapHS.set_cell(2, Vector2i(-6,2), 1, Constants.Tribe.XIN,0)
	TileMapHS.set_cell(2, Vector2i(-5,2), 1, Constants.Tribe.IMP,0)
	TileMapHS.set_cell(2, Vector2i(-4,2), 1, Constants.Tribe.BAR,0)
	TileMapHS.set_cell(2, Vector2i(-3,2), 1, Constants.Tribe.OUM,0)
	TileMapHS.set_cell(2, Vector2i(-2,2), 1, Constants.Tribe.KIC,0)
	TileMapHS.set_cell(2, Vector2i(-1,2), 1, Constants.Tribe.HOO,0)
	
	TileMapHS.set_cell(2, Vector2i(-6,3), 1, Constants.Tribe.LUX,0)
	TileMapHS.set_cell(2, Vector2i(-5,3), 1, Constants.Tribe.VEN,0)
	TileMapHS.set_cell(2, Vector2i(-4,3), 1, Constants.Tribe.ZEB,0)
	TileMapHS.set_cell(2, Vector2i(-3,3), 1, Constants.Tribe.AIM,0)
	TileMapHS.set_cell(2, Vector2i(-2,3), 1, Constants.Tribe.QUE,0)
	TileMapHS.set_cell(2, Vector2i(-1,3), 1, Constants.Tribe.YAD,0)
	
	TileMapHS.set_cell(2, Vector2i(-6,4), 1, Constants.Tribe.AQU,0)
	TileMapHS.set_cell(2, Vector2i(-5,4), 1, Constants.Tribe.ELY,0)
	TileMapHS.set_cell(2, Vector2i(-4,4), 1, Constants.Tribe.POL,0)
	TileMapHS.set_cell(2, Vector2i(-3,4), 1, Constants.Tribe.CYM,0)
	
	TileMapHS.set_cell(2, Vector2i(-2,4), 1, Vector2i(4,2),0)

	


			
func generateAltColors():
	TileMapHS.set_cell(0, Vector2i(-6,5), 0, Constants.Tribe.XIN,0)
	TileMapHS.set_cell(0, Vector2i(-5,5), 0, Constants.Tribe.IMP,0)
	TileMapHS.set_cell(0, Vector2i(-4,5), 0, Constants.Tribe.BAR,0)
	TileMapHS.set_cell(0, Vector2i(-3,5), 0, Constants.Tribe.OUM,0)
	TileMapHS.set_cell(0, Vector2i(-2,5), 0, Constants.Tribe.KIC,0)
	TileMapHS.set_cell(0, Vector2i(-1,5), 0, Constants.Tribe.HOO,0)
	
	TileMapHS.set_cell(0, Vector2i(-6,6), 0, Constants.Tribe.LUX,0)
	TileMapHS.set_cell(0, Vector2i(-5,6), 0, Constants.Tribe.VEN,0)
	TileMapHS.set_cell(0, Vector2i(-4,6), 0, Constants.Tribe.ZEB,0)
	TileMapHS.set_cell(0, Vector2i(-3,6), 0, Constants.Tribe.AIM,0)
	TileMapHS.set_cell(0, Vector2i(-2,6), 0, Constants.Tribe.QUE,0)
	TileMapHS.set_cell(0, Vector2i(-1,6), 0, Constants.Tribe.YAD,0)
	
	TileMapHS.set_cell(0, Vector2i(-6,7), 0, Constants.Tribe.AQU,0)
	TileMapHS.set_cell(0, Vector2i(-5,7), 0, Constants.Tribe.ELY,0)
	TileMapHS.set_cell(0, Vector2i(-4,7), 0, Constants.Tribe.POL,0)
	TileMapHS.set_cell(0, Vector2i(-3,7), 0, Constants.Tribe.CYM,0)
	#	print("player")
	#	print(head[i].player)
	#	print(head[i].location)
	
func selected():
	for i in players:
		if head[i].location == 0:
			return head[i]
	return head[0]
	
#func hider():
#	hid = true
		

	
	#if $tribeSelectExpand.visible == false:
	#	$tribeSelectExpand.visible = true

	#else:
	#	$tribeSelectExpand.visible = false
