extends GroundedState

func enter():
	if !host.crouching:
		host.animation_player.play("crouching_enter")
	else:
		host.animation_player.play("crouching")
	host.crouching = true

func exit():
	host.animation_player.play("crouching_exit")
