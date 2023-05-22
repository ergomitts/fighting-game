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
	var pressing := -1
	if is_pressing("special"):
		pressing = Constants.Buttons.Special
	elif is_pressing("heavy"):
		pressing = Constants.Buttons.Heavy
	elif is_pressing("medium"):
		pressing = Constants.Buttons.Medium
	elif is_pressing("light"):
		pressing = Constants.Buttons.Light
	
	for attack_name in host.attack_states:
		var i = host.get_attack_state(attack_name)
		if i.motion == motion_input and i.button == pressing:
			if (host.grounded() and !i.aerial) or (!host.grounded() and i.aerial):
				state = i.name
				break
			
	return state
	
func process_input():
	var controller := InputManager.controllers[host.id - 1] as Controller
	var input = controller.buffer[controller.BUFFER_FRAMES - 1]
	var axis = input.axis
	
	var buttons = get_buttons()
	
	if buttons.size() > 0:
		var motion_input
		for i in range(Constants.MotionInput.size()):
			var motion = controller.read_motion_input(i, host.flipped)
			if motion:
				motion_input = i
				break
		if motion_input:
			var state = get_attack_state(motion_input)
			if state:
				return state
		
		if controller.read_directional_input(Vector2.LEFT, "special") or controller.read_directional_input(Vector2.DOWN + Vector2.LEFT, "special"):
			return get_attack_state(Constants.MotionInput.QuarterCircleB)
		elif controller.read_directional_input(Vector2.RIGHT, "special"):	
			return get_attack_state(Constants.MotionInput.QuarterCircleF)
		elif controller.read_directional_input(Vector2.DOWN + Vector2.RIGHT, "special"):	
			return get_attack_state(Constants.MotionInput.DragonPunch)
		elif controller.read_directional_input(Vector2.DOWN, "special"):
			return get_attack_state(Constants.MotionInput.HalfCircleF)
		
func process_physics(delta):
	if !host.grounded():
		host.velocity.y += host.gravity
	else:
		host.velocity.x = lerp(host.velocity.x, 0.0, host.friction * delta)
		host.velocity.y = 0		
		
func physics_process(delta):
	process_physics(delta)
	return process_input()
