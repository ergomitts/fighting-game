extends GroundedState

func enter():
	host.animation_player.play("crouching_enter")

func exit():
	host.animation_player.play("crouching_exit")
