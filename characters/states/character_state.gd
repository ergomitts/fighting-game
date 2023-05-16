extends State
class_name CharacterState

func get_input():
	var controller = InputManager.controllers[host.id - 1]
	var input = controller.buffer[controller.BUFFER_FRAMES - 1]
	return input

func get_axis():
	var controller = InputManager.controllers[host.id - 1]
	return controller.get_axis()
	
func get_flipped():
	return -1 if host.flipped else 1
	
func get_dir():
	var axis = get_axis()
	var dir = axis.x * get_flipped()
	return dir
	
func process_input():
	var controller = InputManager.controllers[host.id - 1]
	var input = controller.buffer[controller.BUFFER_FRAMES - 1]
	var axis = input.axis
	
	var buttons = controller.check_buttons()
	var qcf = controller.check_qcf(host.flipped)
	var f_dash = controller.check_fdash(host.flipped)
	var b_dash = controller.check_bdash(host.flipped)
	
	if qcf:
		if buttons.has("light"):
			return "FDash"
	if f_dash:
		return "FDash"
	if b_dash:
		return "BDash"
	
	
	if axis.y < 0:
		return "Prejump"
	if abs(axis.x) > 0:
		return "Walking"
	if axis.x == 0 and axis.y == 0:
		return "Idle"

func physics_process(delta):
	if !host.grounded():
		host.velocity.y += host.gravity
	else:
		host.velocity.y = 0
