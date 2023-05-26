extends CharacterState

var time := 0.0

func enter():
	time = 0.0
	host.face_target()
	if name == "FDash":
		host.velocity.x = 75 * get_flipped()
	else:
		host.velocity.x = -45 * get_flipped()

func exit():
	host.face_target()
	host.velocity.x = 0
	
func physics_process(delta):
	super.physics_process(delta)
	time += delta
	if time >= 0.1:
		return "Idle"
			
	
