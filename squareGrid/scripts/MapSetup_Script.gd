extends Control


var grideSizeMS = 11
var playersMS = 1



func _on_play_pressed():
	#Global.players = playersMS
	#Global.gridSize = grideSizeMS
	#print(Global.players)
	get_tree().change_scene_to_file("res://scenes/2dScene.tscn") # Replace with function body.

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn") # Replace with function body.
