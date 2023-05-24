extends AerialState

func enter():
	host.animation_player.play("prejump")
	
func physics_process(delta):
	if host.animation_finished():
		return "Jumping"
	
