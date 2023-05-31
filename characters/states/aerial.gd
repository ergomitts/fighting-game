extends CharacterState
class_name AerialState

func enter():
	host.animation_player.play("falling")

func process_physics(delta):
	host.velocity.y += host.gravity
	host.velocity.x = lerp(host.velocity.x, 0.0, host.drag * delta)

func physics_process(delta):
	if host.grounded():
		return "Landing"
	return super.physics_process(delta)
