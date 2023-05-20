extends AerialState

func enter():
	host.animation_player.play("Prejump")
	
func physics_process(delta):
	if host.animation_finished():
		return "Jumping"
	
