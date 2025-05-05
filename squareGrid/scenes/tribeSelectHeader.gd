extends NinePatchRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_select_button_pressed():
	if $tribeSelectExpand.visible == false:
		$tribeSelectExpand.visible = true
	else:
		$tribeSelectExpand.visible = false
