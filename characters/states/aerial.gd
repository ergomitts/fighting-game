extends CharacterState
class_name AerialState

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
	
