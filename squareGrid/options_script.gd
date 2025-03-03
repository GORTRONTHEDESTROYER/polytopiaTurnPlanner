extends Control

# Called when the node enters the scene tree for the first time.

func _on_options_pressed():
	pass # Replace with function body.
	
func _on_go_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")

