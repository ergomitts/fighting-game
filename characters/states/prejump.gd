extends CharacterState

func enter():
	host.animation_player.play("prejump")
	host.grab_immune = true
	
func exit():
	host.grab_immune = false
	
func physics_process(delta):
	if host.animation_finished():
		return "Jumping"
	
