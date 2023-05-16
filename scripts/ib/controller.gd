extends Node
class_name Controller

const BUFFER_FRAMES = 30
const CHARGE_FRAMES = 40
const CHARGE_DELAY_FRAMES = 12

var actions := []
var buffer := []

var charge_axis := Vector2i.ZERO
var charge_time := 0 
var charge_delay := 0

var id := 1

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
	
func check_buttons():
	var buttons = {}
	for i in range(BUFFER_FRAMES - 1, BUFFER_FRAMES - 20, -1):
		var input = buffer[i]
		var _buttons = input.buttons
		if _buttons.size() > 0:
			buttons = _buttons
			break
	return buttons
	
func check_qcf(flipped):
	var p = 0
	var passed = false
	for i in range(BUFFER_FRAMES - 1, BUFFER_FRAMES - 14, -1):
		var input = buffer[i]
		var axis = input.axis
		if flipped:
			axis.x *= -1
		if p == 0:
			if axis.x != 1 or axis.y != 0:
				break
		if p == 1:
			if axis.x != 1 or axis.y != 1:
				continue
		if p == 2:
			if axis.y != 1 or axis.x != 0:
				break
		p += 1
		if p >= 2:
			passed = true
			break
	return passed	
	
func check_fdash(flipped):
	var p = 0
	var passed = false
	for i in range(BUFFER_FRAMES - 1, BUFFER_FRAMES - 12, -1):
		var input = buffer[i]
		var axis = input.axis
		if flipped:
			axis.x *= -1
		if p == 0:
			if axis.x != 1:
				continue
		if p == 1:
			if axis.x != 0:
				continue
		if p == 2:
			if axis.x != 1:
				continue
		if p == 3:
			if axis.x != 0:
				continue
		p += 1
		if p >= 4:
			passed = true
			break
	return passed
	
func check_bdash(flipped):
	var p = 0
	var passed = false
	for i in range(BUFFER_FRAMES - 1, BUFFER_FRAMES - 12, -1):
		var input = buffer[i]
		var axis = input.axis
		if flipped:
			axis.x *= -1
		if p == 0:
			if axis.x != -1:
				continue
		if p == 1:
			if axis.x != 0:
				continue
		if p == 2:
			if axis.x != -1:
				continue
		if p == 3:
			if axis.x != 0:
				continue
		p += 1
		if p >= 4:
			passed = true
			break
	return passed

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
			elif Input.is_action_pressed(action):
				input.buttons[raw_action] = 0
			elif Input.is_action_just_released(action):
				input.buttons[raw_action] = -1
	return input
	
func update_charge(axis):
	if axis.x == charge_axis.x and axis.y == charge_axis.y:
		if charge_time < CHARGE_FRAMES:
			charge_time += 1
		if charge_delay > 0:
			charge_delay -= 1
	else:
		charge_axis = axis
		charge_time = 0 
		if charge_time == CHARGE_FRAMES:
			charge_delay = CHARGE_DELAY_FRAMES
		else:
			charge_delay = 0
	
func update():
	var _input = process_input()
	update_charge(_input.axis)
	buffer.pop_front()
	buffer.append(_input)

	
