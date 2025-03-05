class_name Tile
var type = null
var tribe = null
var pos = null
var res = 0
func _init(typeP,tribeP,posP):
	type = typeP
	tribe = tribeP
	pos = posP

	###print(tribe)
func tileType(typeP):
	type = typeP
func tileResource(resP):

	res = resP
	#print(res)
