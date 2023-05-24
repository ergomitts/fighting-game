extends CharacterState

func enter():
	host.face_target()
	
func exit():
	pass
	
func physics_process(delta):
	process_physics(delta)
	if host.hitstun == 0:
		return "Grounded"
