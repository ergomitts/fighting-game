extends CharacterState
class_name AerialState

func enter():
	host.animation_player.play("falling")

func physics_process(delta):
	if host.grounded():
		return "Landing"
	return super.physics_process(delta)
