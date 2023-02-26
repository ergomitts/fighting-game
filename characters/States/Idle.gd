extends State
class_name Idle

func physics_process(delta: float):
	var h_dir = 0
	var pressed_jump = false
	if host.id == 0:
		h_dir = Input.get_action_raw_strength('p1_right') - Input.get_action_raw_strength('p1_left')
		pressed_jump = Input.is_action_just_pressed('p1_up')
	else:
		h_dir = Input.get_action_raw_strength('p2_right') - Input.get_action_raw_strength('p2_left')
		pressed_jump = Input.is_action_just_pressed('p2_up')
	host.velocity.x = h_dir * 20
	if pressed_jump:
		host.velocity.y = -50
