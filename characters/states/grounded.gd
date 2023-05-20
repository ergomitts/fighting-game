extends CharacterState
class_name GroundedState

var stance := Constants.Stance.Normal

func enter():
	host.velocity.y = 0 
	host.face_target()
	host.animation_player.play("standing")
	
func animation_finished(anim_name):
	if stance == Constants.Stance.Normal:
		host.animation_player.play("standing")
	elif stance == Constants.Stance.Crouching:
		host.animation_player.play("crouching")	
	
func change_stance(new_stance):
	if stance != new_stance:
		stance = new_stance
		if stance == Constants.Stance.Normal:
			host.animation_player.play("crouch_exit")
		elif stance == Constants.Stance.Crouching:
			host.animation_player.play("crouch_enter")
		
func process_stance(delta):
	var axis = get_axis()
	if axis.y == 1:
		change_stance(Constants.Stance.Crouching)
	else:
		change_stance(Constants.Stance.Normal)
	if stance == Constants.Stance.Normal:
		if host.animation_finished():
			host.animation_player.play("standing")
	elif stance == Constants.Stance.Crouching:
		if host.animation_finished():
			host.animation_player.play("crouching")

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
		
		if stance != Constants.Stance.Crouching:
			var grab_combo = controller.check_combined_buttons(["light", "medium"])
			if grab_combo:
				return "Grab"
			
		if controller.read_directional_input(Vector2.LEFT, "special") or controller.read_directional_input(Vector2.DOWN + Vector2.LEFT, "special"):
			return get_attack_state(Constants.MotionInput.QuarterCircleB)
		elif controller.read_directional_input(Vector2.RIGHT, "special"):	
			return get_attack_state(Constants.MotionInput.QuarterCircleF)
		elif controller.read_directional_input(Vector2.DOWN + Vector2.RIGHT, "special"):	
			return get_attack_state(Constants.MotionInput.DragonPunch)
		elif controller.read_directional_input(Vector2.DOWN, "special"):
			return get_attack_state(Constants.MotionInput.HalfCircleF)
			
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
	return super.physics_process(delta)
