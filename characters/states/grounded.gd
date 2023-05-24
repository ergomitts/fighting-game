extends CharacterState
class_name GroundedState

func enter():
	host.velocity.y = 0 
	host.face_target()
	host.animation_player.play("standing")
	
func animation_finished(anim_name):
	if host.stance == Constants.Stance.Normal:
		host.animation_player.play("standing")
	elif host.stance == Constants.Stance.Crouching:
		host.animation_player.play("crouching")	
	
func change_stance(new_stance):
	if host.stance != new_stance:
		host.stance = new_stance
		if host.stance == Constants.Stance.Normal:
			host.animation_player.play("crouching_exit")
		elif host.stance == Constants.Stance.Crouching:
			host.animation_player.play("crouching_enter")
		
func process_stance(delta):
	var axis = get_axis()
	if axis.y == 1:
		change_stance(Constants.Stance.Crouching)
	else:
		change_stance(Constants.Stance.Normal)
	if host.stance == Constants.Stance.Normal:
		if host.animation_finished():
			host.animation_player.play("standing")
	elif host.stance == Constants.Stance.Crouching:
		if host.animation_finished():
			host.animation_player.play("crouching")

func process_input():
	var state = super.process_input()
	if state:
		return state
	
	var controller := InputManager.controllers[host.id - 1] as Controller
	var axis = controller.get_axis()
	
	if host.stance == Constants.Stance.Normal:
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
	
func physics_process(delta):
	process_stance(delta)
	if !host.in_corner():
		host.face_target()
	return super.physics_process(delta)
