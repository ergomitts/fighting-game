extends GroundedState

func enter():
<<<<<<< HEAD
	host.animation_player.play("crouching_enter")
=======
	if !host.crouching:
		host.animation_player.play("crouching_enter")
	else:
		host.animation_player.play("crouching")
	host.crouching = true
>>>>>>> dev

func exit():
	host.animation_player.play("crouching_exit")
