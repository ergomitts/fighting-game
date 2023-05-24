extends GroundedState
class_name StandState

func enter():
	host.animation_player.play("standing")

func process_input():
	var state = super.process_input()
	if state and state != "Standing":
		return state
	
	var controller := InputManager.controllers[host.id - 1] as Controller
	var axis = controller.get_axis()

	var grab_combo = controller.check_combined_buttons(["light", "medium"])
	if grab_combo:
		return "Grab"
			
	if controller.read_motion_input(Constants.MotionInput.DTapF, host.flipped):
		return "ForwardDash"
	elif controller.read_motion_input(Constants.MotionInput.DTapB, host.flipped):
		return "BackDash"
	
	if axis.y == -1:
		return "Prejump"
	elif abs(axis.x) > 0 and axis.y == 0:
		return "Walking"
	else:
		return "Grounded"
