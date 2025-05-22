extends ScrollContainer


@export var card_scale = 1 # (float, 0.5, 1, 0.1)
@export var card_current_scale = 1.2 # (float, 1, 1.5, 0.1)
@export var scroll_duration = 0 # (float, 0.1, 1, 0.1)

var card_current_index: int = 0
var card_x_positions: Array = []

@onready var scroll_tween: Tween 
@onready var margin_r: int = $CenterContainer/MarginContainer.get("theme_override_constants/margin_right") + 200
@onready var card_space: int = $CenterContainer/MarginContainer/HBoxContainer.get("theme_override_constants/separation")
@onready var card_nodes: Array = $CenterContainer/MarginContainer/HBoxContainer.get_children()


func _ready() -> void:	
	
	#get_h_scroll_bar().set_min(576)
	#get_h_scroll_bar().set_max(1000)
	#get_h_scroll_bar().set_max(3000)
	get_h_scroll_bar().modulate.a = 0
	call_deferred("_set_initial_positions")
		
	
func _set_initial_positions()->void:
	for _card in card_nodes:
		var _card_pos_x: float = (margin_r + _card.position.x) - ((size.x - _card.size.x)/2 )		
		_card.pivot_offset = (_card.size/2)
		card_x_positions.append(_card_pos_x-210)
	scroll_horizontal = card_x_positions[card_current_index]
	scroll()

var i = 0

func _process(delta: float) -> void:
	i = i + 1
	for _index in range(card_x_positions.size()):
		var _card_pos_x: float = card_x_positions[_index]
		var _swipe_length: float = (card_nodes[_index].size.x / 2) + (card_space / 2)
		var _swipe_current_length: float = abs(_card_pos_x - scroll_horizontal)
		#_swipe_current_length = 100
		var _card_scale: float = remap(_swipe_current_length, _swipe_length, 0, card_scale, card_current_scale)
		#var _card_opacity: float = remap(_swipe_current_length, _swipe_length, 0, 0.3, 1)
		
		#var _delta_card_pos_x = _card_pos_x

		if i > 60:
			i = 0	
			#set_h_scroll(200)
			#scroll_tweenss.stop()
			#margin_r = 100
			#_swipe_current_length = 200
			#print(_swipe_current_length)
			#print(card_x_positions[_index])
			#print("true")
		
		
		_card_scale = clamp(_card_scale, card_scale, card_current_scale)
		#_card_opacity = clamp(_card_opacity, 0.3, 1)
		
		card_nodes[_index].scale = Vector2(_card_scale, _card_scale)
		#card_nodes[_index].modulate.a = _card_opacity
		
		if _swipe_current_length < _swipe_length:
			card_current_index = _index
			print(card_current_index)
			
		#left_click(Vector2(_card_pos_x-200,324))
			
			
		
var _delta_swipe_current_length

func scroll() -> void:	
	#pass
	scroll_tween = create_tween().set_parallel(true)
	scroll_tween.tween_property(
		self,
		"scroll_horizontal",
		card_x_positions[card_current_index],
		scroll_duration).from(scroll_horizontal).set_trans(scroll_tween.TRANS_BACK).set_ease(scroll_tween.EASE_OUT)
	
	for _index in range(card_nodes.size()):
		var _card_scale: float = card_current_scale if _index == card_current_index else card_scale
		scroll_tween.tween_property(card_nodes[_index],"scale",Vector2(_card_scale,_card_scale),scroll_duration,).from(card_nodes[_index].scale).set_trans(scroll_tween.TRANS_QUAD).set_ease(scroll_tween.EASE_OUT)

			


func _on_ScrollContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			scroll_tween.stop()
		else:
			scroll()
			
func left_click(pos):
	var press = InputEventMouseButton.new()
	press.set_button_index(MOUSE_BUTTON_LEFT)
	press.set_position(pos)
	press.set_pressed(true)
	Input.parse_input_event(press)
	var release = InputEventMouseButton.new()
	release.set_button_index(MOUSE_BUTTON_LEFT)
	release.set_position(pos)
	release.set_pressed(false)
	Input.parse_input_event(release)


func _on_button_pressed():
	print("test") # Replace with function body.
