extends Camera2D

# Camera control settings:
# key - by keyboard
# drag - by clicking mouse button, right mouse button by default;
# edge - by moving mouse to the window edge
# wheel - zoom in/out by mouse wheel
var key = true
var drag = true
var edge = false
var wheel = true

var zoom_out_limit = 100

# Camera speed in px/s.
var camera_speed = 450 

# Initial zoom value taken from Editor.
var camera_zoom = get_zoom()

# Value meaning how near to the window edge (in px) the mouse must be,
# to move a view.
var camera_margin = 50

# It changes a camera zoom value in units... (?, but it works... it probably
# multiplies camera size by 1+camera_zoom_speed)
const camera_zoom_speed = Vector2(0.5, 0.5)

# Vector of camera's movement / second.
var camera_movement = Vector2()

# Previous mouse position used to count delta of the mouse movement.
var _prev_mouse_pos = null

# INPUTS

# Right mouse button was or is pressed.
var __rmbk = false
# Move camera by keys: left, top, right, bottom.
var __keys = [false, false, false, false]


func _physics_process(delta):
	# Move camera by keys defined in InputMap (ui_left/top/right/bottom).
	if key:
		if __keys[0]:
			camera_movement.x -= camera_speed * delta
		if __keys[1]:
			camera_movement.y -= camera_speed * delta
		if __keys[2]:
			camera_movement.x += camera_speed * delta
		if __keys[3]:
			camera_movement.y += camera_speed * delta
	
	# Move camera by mouse, when it's on the margin (defined by camera_margin).
	if edge:
		var rec = get_viewport().get_visible_rect()
		var v = get_local_mouse_position() + rec.size/2
		if rec.size.x - v.x <= camera_margin:
			camera_movement.x += camera_speed * delta
		if v.x <= camera_margin:
			camera_movement.x -= camera_speed * delta
		if rec.size.y - v.y <= camera_margin:
			camera_movement.y += camera_speed * delta
		if v.y <= camera_margin:
			camera_movement.y -= camera_speed * delta
	
	# When RMB is pressed, move camera by difference of mouse position
	if drag and __rmbk:
		camera_movement = _prev_mouse_pos - get_local_mouse_position()
	
	# Update position of the camera.
	position += camera_movement * get_zoom()
	
	# Set camera movement to zero, update old mouse position.
	camera_movement = Vector2(0,0)
	_prev_mouse_pos = get_local_mouse_position()

func _unhandled_input( event ):
		# Check if mouse wheel was used. Not handled by ImputMap!
		#if wheel:
			# Checking if future zoom won't be under 0.
			# In that cause engine will flip screen.
			#if event.button_index == BUTTON_WHEEL_UP and\
			#camera_zoom.x - camera_zoom_speed.x > 0 and\
			#camera_zoom.y - camera_zoom_speed.y > 0:
				#camera_zoom -= camera_zoom_speed
				#set_zoom(camera_zoom)
				# Checking if future zoom won't be above zoom_out_limit.
			#if event.button_index == BUTTON_WHEEL_DOWN and\
			#camera_zoom.x + camera_zoom_speed.x < zoom_out_limit and\
			#camera_zoom.y + camera_zoom_speed.y < zoom_out_limit:
			#	camera_zoom += camera_zoom_speed
			#	set_zoom(camera_zoom)
	# Control by keyboard handled by InpuMap.
	if event.is_action_pressed("A"):
		__keys[0] = true
	if event.is_action_pressed("W"):
		__keys[1] = true
	if event.is_action_pressed("D"):
		__keys[2] = true
	if event.is_action_pressed("S"):
		__keys[3] = true
	if event.is_action_released("A"):
		__keys[0] = false
	if event.is_action_released("W"):
		__keys[1] = false
	if event.is_action_released("D"):
		__keys[2] = false
	if event.is_action_released("S"):
		__keys[3] = false
