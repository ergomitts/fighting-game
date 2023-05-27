extends CharacterState

func enter():
	host.face_target()
	host.animation_player.stop()
	if host.grounded():
		if host.crouching:
			host.animation_player.play("crouch_blocking")
		else:
			host.animation_player.play("standing_blocking")
	else:
		host.animation_player.play("air_blocking")
	
func physics_process(delta):
	process_physics(delta)
	if host.hitstun == 0:
		if host.grounded():
			return "Landing"
		else:
			return "Aerial"
