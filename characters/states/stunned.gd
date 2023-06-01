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
	var burst_combo = controller.check_combined_buttons(["light", "medium", "heavy"])
	if burst_combo and host.special.value >= 100:
		return "Burst"

func physics_process(delta):
	process_physics(delta)
	if host.hitstun == 0:
		return "Grounded"
	return process_input()
