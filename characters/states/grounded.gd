extends CharacterState
class_name GroundedState

func enter():
	host.velocity.y = 0 
	host.face_target()
<<<<<<< HEAD
=======
	host.jumps = host.max_jumps
>>>>>>> dev

func process_input():
	var state = super.process_input()
	if state:
		return state
	
	var controller := InputManager.controllers[host.id - 1] as Controller
	var axis = controller.get_axis()
	
	if controller.read_motion_input(Constants.MotionInput.DTapF, host.flipped):
		return "Running"
	elif controller.read_motion_input(Constants.MotionInput.DTapB, host.flipped):
		return "BackDash"
	
	if axis.y == 1:
		return "Crouching"
<<<<<<< HEAD
	elif axis.y == -1:
		return "Prejump"
	elif abs(axis.x) > 0:
=======
	elif axis.y == -1 and host.jumps > 0:
		host.crouching = false
		return "Prejump"
	elif abs(axis.x) > 0:
		host.crouching = false
>>>>>>> dev
		if name != "Running":
			return "Walking"
		else:
			return "Running"
	else:
		return "Standing"
	
func physics_process(delta):
<<<<<<< HEAD
	if !host.in_corner() and !host.nemesis.in_corner():
		host.face_target()
=======
	host.face_target()
>>>>>>> dev
	return super.physics_process(delta)
