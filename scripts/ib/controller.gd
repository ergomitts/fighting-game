extends Node
class_name Controller

const BUFFER_FRAMES = 30
const CHARGE_FRAMES = 40
const CHARGE_DELAY_FRAMES = 12

var actions := []
var buffer := []

var charge_axis := Vector2.ZERO
var charge_time := 0 
var charge_delay := 0

var id := 1

var has_changed = false
signal changed

func _ready():
	buffer.resize(BUFFER_FRAMES)
	buffer.fill(FGInput.new())
	
	for action in InputMap.get_actions():
			if ('p' + str(id) + '_') in action:
				actions.append(action)
				
func clear():
	buffer.fill(FGInput.new())

func get_axis():
	var axis = buffer[BUFFER_FRAMES - 1].axis
	return Vector2(axis.x, axis.y)
	
func get_buttons(frame := BUFFER_FRAMES):
	var buttons = buffer[frame - 1].buttons
	return buttons

func is_pressing(button := "") -> bool:
	for i in range(BUFFER_FRAMES, BUFFER_FRAMES - 5, -1):
		var buttons = get_buttons(i)
		if buttons.has(button):
			return buttons.get(button) == 1
	return false
	
func check_combined_buttons(combo_buttons := [], duration := 10, start := BUFFER_FRAMES - 1):
	var found_buttons := []
	start = max(start, (BUFFER_FRAMES - 1) - duration)
	for i in range(start, (BUFFER_FRAMES - 1) - duration, -1):
		var buttons := buffer[i].buttons as Dictionary
		for x in combo_buttons:
			if buttons.has(x) and !found_buttons.has(x):
				if buttons.get(x) > 0:
					found_buttons.append(x)
		if found_buttons.hash() == combo_buttons.hash():
			break
	return found_buttons.hash() == combo_buttons.hash()
	
func read_directional_input(c_axis: Vector2, c_button: String, flipped := false, duration := 10, start := BUFFER_FRAMES - 1):
	start = max(start, (BUFFER_FRAMES - 1) - duration)
	var c0 = false
	var c1 = false
	for i in range(start, (BUFFER_FRAMES - 1) - duration, -1):
		var axis := buffer[i].axis as Vector2
		var button := buffer[i].buttons as Dictionary
		if flipped:
			axis.x *= -1
		if !c0:
			c0 = axis == c_axis 
		if !c1:
			if button.has(c_button):
				c1 = button.get(c_button, -1) >= 0
		if c0 and c1:
			break
	return c0 and c1
		
func read_motion_input(index: int, flipped := false, start := BUFFER_FRAMES - 1):
	var failed = true
	
	if index == Constants.MotionInput.Empty:
		return true
	
	if Constants.MOTION_INPUT_DATA.has(index):
		var duration := Constants.MOTION_INPUT_DATA[index].get('duration', 0) as int
		var directions := Constants.MOTION_INPUT_DATA[index].get('directions', []) as Array
		var misinputs := Constants.MOTION_INPUT_DATA[index].get('misinputs', 0) as int
		
		var checks := directions.size() - 1
		var mistakes := 0 
		var last_dir := Vector2(99, 99)
		
		start = max(start, (BUFFER_FRAMES - 1) - duration)
		for i in range(start, (BUFFER_FRAMES - 1) - duration, -1):
			var dir := buffer[i].axis as Vector2
			
			if mistakes > misinputs:
				break
			
			if checks >= 0:
				if directions[checks] is Vector2:
					var target_dir = directions[checks] * (Vector2(-1, 1) if flipped else Vector2.ONE)
					if dir == target_dir:
						checks -= 1
					elif last_dir != dir:
						mistakes += 1
					
			if checks < 0:
				failed = false
				break
			last_dir = dir

	return !failed

func process_input():
	var input = FGInput.new()
	for action in actions:
		var raw_action = action.substr(3)
		if raw_action == "up" or raw_action == "down" or raw_action == "left" or raw_action == "right":
			var strength := 1 if Input.is_action_pressed(action) else 0
			match raw_action:
				"up":
					input.axis.y += -strength
				"down":
					input.axis.y += strength
				"left":
					input.axis.x += -strength
				"right":
					input.axis.x += strength
		else:
			if Input.is_action_just_pressed(action):
				input.buttons[raw_action] = 1 
				has_changed = true
			elif Input.is_action_pressed(action):
				var prev = buffer[(BUFFER_FRAMES - 1) - 4]
				if prev.buttons.get(raw_action, -1) == -1:
					input.buttons[raw_action] = 1
				else:
					input.buttons[raw_action] = 0
			elif Input.is_action_just_released(action):
				input.buttons[raw_action] = -1
				has_changed = true
	return input
	
func update_charge(axis):
	if axis.x == charge_axis.x and axis.y == charge_axis.y:
		if charge_time < CHARGE_FRAMES:
			charge_time += 1
		if charge_delay > 0:
			charge_delay -= 1
	else:
		has_changed = true
		charge_axis = axis
		charge_time = 0 
		if charge_time == CHARGE_FRAMES:
			charge_delay = CHARGE_DELAY_FRAMES
		else:
			charge_delay = 0
	
func update():
	var _input = process_input()
	buffer.pop_front()
	buffer.append(_input)
	update_charge(_input.axis)
	if has_changed:
		has_changed = false
		changed.emit(id)

	
