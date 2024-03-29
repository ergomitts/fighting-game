extends CharacterState

var air_blocking := false

func enter():
	host.face_target()
	host.animation_player.stop()
	air_blocking = !host.grounded()
	if host.grounded():
		if host.crouching:
			host.animation_player.play("crouch_blocking")
		else:
			host.animation_player.play("standing_blocking")
	else:
		host.animation_player.play("air_blocking")

func process_input():
	var controller := InputManager.controllers[host.id - 1] as Controller
	var burst_combo = controller.check_combined_buttons(["light", "medium", "heavy"])
	if burst_combo and host.special.value >= 100:
		return "Burst"
	
func physics_process(delta):
	process_physics(delta)
	if host.hitstun == 0:
		if !air_blocking:
			return "Grounded"
		else:
			if host.grounded():
				return "Landing"
			else:
				return "Aerial"
	return process_input()
