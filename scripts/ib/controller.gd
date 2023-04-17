extends Node
class_name Controller

const BUFFER_FRAMES = 30
const CHARGE_FRAMES = 40
const CHARGE_DELAY_FRAMES = 12

var actions := []
var buffer := []
var pressed := []

var charge_axis := {"x" : 0, "y" : 0}
var charge_time := 0 
var charge_delay := 0

var id := 1

func _ready():
	buffer.resize(BUFFER_FRAMES)
	buffer.fill(FGInput.new())
	
	for action in InputMap.get_actions():
			if ('p' + str(id) + '_') in action:
				actions.append(action)

func check_motion():
	var passed := false
	
	pass

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
				input.buttons[action] = 1
			elif Input.is_action_pressed(action):
				input.buttons[action] = 0
			elif Input.is_action_just_released(action):
				input.buttons[action] = -1
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

	
