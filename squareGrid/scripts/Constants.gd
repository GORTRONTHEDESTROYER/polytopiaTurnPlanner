class_name Constants

enum TileType {NONE, FIELD, FOREST, MOUNTAIN, CLOUD, UNIT, SHORES, OCEAN}
#enum Tribe {XIN,IMP}
const Tribe = { 
	XIN = Vector2i(0,0), IMP = Vector2i(1,0), BAR = Vector2i(2,0), 
	OUM = Vector2i(3,0), KIC = Vector2i(4,0), HOO = Vector2i(5,0),
	LUX = Vector2i(6,0), VEN = Vector2i(1,1), ZEB = Vector2i(2,1),
	AIM = Vector2i(3,1), QUE = Vector2i(4,1), YAD = Vector2i(5,1),
	AQU = Vector2i(6,1), ELY = Vector2i(0,2), POL = Vector2i(1,2),
	CYM = Vector2i(2,2)
}
enum Asset {SELECTION, FIELD, FOREST, MOUNTAIN, FRUIT, ANIMAL, CROP, 
	METAL, CLOUD, WARRIOR, BLANK, MOVETARGET, ZOC1MOVETARGET, ZOC2MOVETARGET, ROAD, UNITBODY, UNITHEAD, SHORES, OCEAN, RUIN, VILLAGE} 
enum UnitType {NONE, WARRIOR}
enum BuildingType {NONE, ROAD, RUIN, VILLAGE}
#enum Player {ONE, TWO, THREE, FOUR, FIVE, SIX}
