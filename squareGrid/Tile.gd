class_name Tile
var type = null
var tribe = null
var pos = null
var res = 0

func _init(typeP,tribeP,posP):
	type = typeP
	tribe = tribeP
	pos = posP

	print(pos)
	print(type)
	print(tribe)
func tileResource(resP):
	res = resP
	return res
	
	
	
