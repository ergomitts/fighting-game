extends CharacterState
class_name GroundedState

func enter():
	host.velocity.y = 0 
	host.face_target()
	host.animation_player.play("standing")

func process_input():
	var state = super.process_input()
	if state:
		return state
	
	var controller := InputManager.controllers[host.id - 1] as Controller
	var axis = controller.get_axis()
	
	if axis.y == 1:
		return "Crouching"
	else:
		return "Standing"
	
func physics_process(delta):
	if !host.in_corner() and !host.nemesis.in_corner():
		host.face_target()
	return super.physics_process(delta)
