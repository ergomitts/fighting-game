extends CharacterState
class_name StunnedState

func enter():
	host.face_target()
	host.animation_player.stop()
	if host.crouching:
		host.animation_player.play("crouching_stunned")
	else:
		host.animation_player.play("standing_stunned")

func process_input():
	var controller := InputManager.controllers[host.id - 1] as Controller
	var input = controller.buffer[controller.BUFFER_FRAMES - 1]
	var axis = input.axis
	
	var buttons = get_buttons()
	
	var burst_combo = controller.check_combined_buttons(["light", "medium", "heavy", "special"])
	if burst_combo:
		return "Burst"

func physics_process(delta):
	process_physics(delta)
	if host.hitstun == 0:
		return "Grounded"
	return process_input()
