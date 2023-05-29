extends CharacterState

func enter():
	host.animation_player.play("prejump")
	host.grab_immune = true
	if host.jumps > 0:
		host.jumps -= 1
	
func exit():
	host.grab_immune = false
	
func physics_process(delta):
	if host.animation_finished() or !host.grounded():
		return "Jumping"
	
