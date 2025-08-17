extends TileMap

@export var unitBoard: Node2D
@export var tileSelectPing: Node2D


#func updateTribe(head):
	#set_cell(1,Vector2i(0,1 + head.location),0,head.tribe,0)
	
	
	
func update(head):
	
	

	#head
	set_cell(1,Vector2i(0,1 + head.location),1,head.tribe,0)
	#color
	set_cell(0,Vector2i(0,1 + head.location),0,head.color,0)
	
	unitBoard.updateAllUnitLook()
	unitBoard.updateAllTileLook()
	
	
	#for i in Global.players:
		
	tileSelectPing.ping(head)
	
func update2(head):
	
	

	#head
	set_cell(1,Vector2i(0,1 + head.location),1,head.tribe,0)
	#color
	set_cell(0,Vector2i(0,1 + head.location),0,head.color,0)
	
	unitBoard.updateAllUnitLook()
	unitBoard.updateAllTileLook()
		
func hideUnselected(ip)->void:
	for i in ip:
		if i == 0:
			pass
		else:
			erase_cell(0,Vector2i(0,1+i))
			erase_cell(1,Vector2i(0,1+i))

			erase_cell(2,Vector2i(0,1+i))
			
			for j in 6:
				for k in 6:
					erase_cell(2,Vector2i(-6+k,2+j))
					erase_cell(0,Vector2i(-6+k,2+j))
			
