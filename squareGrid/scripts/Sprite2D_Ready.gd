extends Sprite2D

func _ready():
	var screen_size = DisplayServer.screen_get_size()
	var relative_size
	var res
	var rand = randi_range(0, 2) 
	#var array_3 = []
	#rand = 2
	#print(rand)
	match rand:
		0:
			res = load("res://imageHolder/mainMenuBackgrounds/woe.png")
			texture = res
		1:
			res = load("res://imageHolder/mainMenuBackgrounds/cymantiPolarisdoing.png")
			texture = res #525 x 521
			
			relative_size = Vector2i(525,521)/screen_size
			position = screen_size * relative_size
			scale = Vector2i(1,1)
			
		2:
			res = load("res://imageHolder/mainMenuBackgrounds/ILOVEPOLYTOPIA002.png")
			texture = res #1079 x 1280
			
			relative_size = Vector2i(1079*.6 , 1280*.6)/screen_size
			position = screen_size * relative_size
			scale = Vector2(.6,.6)
			
			
			
	set_texture(texture)
