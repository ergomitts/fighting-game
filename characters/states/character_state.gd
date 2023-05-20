extends State
class_name CharacterState

func get_input() -> FGInput:
	var controller = InputManager.controllers[host.id - 1]
	var input = controller.buffer[controller.BUFFER_FRAMES - 1]
	return input
func get_axis() -> Vector2:
	var controller = InputManager.controllers[host.id - 1]
	return controller.get_axis()
func get_buttons() -> Dictionary:
	var controller = InputManager.controllers[host.id - 1]
	return controller.get_buttons()
func get_flipped() -> int:
	return -1 if host.flipped else 1
func get_dir() -> int:
	var axis = get_axis()
	var dir = axis.x * get_flipped()
	return dir
func is_pressing(button := "") -> bool:
	var controller = InputManager.controllers[host.id - 1]
	return controller.is_pressing(button)
	
func get_attack_state(motion_input):
	var state := ""
	var pressing := 0
	if is_pressing("special"):
		pressing = Constants.Buttons.Special
	elif is_pressing("heavy"):
		pressing = Constants.Buttons.Heavy
	elif is_pressing("medium"):
		pressing = Constants.Buttons.Medium
	elif is_pressing("light"):
		pressing = Constants.Buttons.Light
	
	for i in host.attack_states:
		if i.motion == motion_input and i.button == pressing:
			if (host.is_grounded() and !i.aerial) or (!host.is_grounded and i.aerial):
				state = i.name
				break
			
	return state
	
func process_input():
	pass
		
func physics_process(delta):
	if !host.grounded():
		host.velocity.y += host.gravity
	else:
		host.velocity.x = lerp(host.velocity.x, 0.0, host.friction * delta)
		host.velocity.y = 0
	return process_input()
