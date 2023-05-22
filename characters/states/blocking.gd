extends GroundedState

func enter():
	host.face_target()
	
func exit():
	pass
	
func physics_process(delta):
	process_physics(delta)
	process_stance(delta)
	if host.hitstun == 0:
		return "Grounded"
