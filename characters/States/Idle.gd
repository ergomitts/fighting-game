extends State
class_name Idle

func physics_process(delta: float):
	var h_dir = 0
	var pressed_jump = false
	var pressed_down = false
	if host.id == 0:
		h_dir = Input.get_action_raw_strength('p1_right') - Input.get_action_raw_strength('p1_left')
		pressed_jump = Input.is_action_just_pressed('p1_up')
		pressed_down = Input.is_action_pressed('p1_down')
	else:
		h_dir = Input.get_action_raw_strength('p2_right') - Input.get_action_raw_strength('p2_left')
		pressed_jump = Input.is_action_just_pressed('p2_up')
		pressed_down = Input.is_action_pressed('p2_down')
	host.velocity.x = h_dir * 20
	if pressed_jump:
		host.velocity.y = -50
	if pressed_down:
		host.push_box.shape.size.x = 125
		host.push_box.shape.position.x = -125/2
		host.push_box.shape.size.y = 250
		host.push_box.shape.position.y = -250/2
	else:
		host.push_box.shape.size.x = 250
		host.push_box.shape.position.x = -250/2
		host.push_box.shape.size.y = 650
		host.push_box.shape.position.y = -650/2
