extends StunnedState

func enter():
	host.animation_player.stop()
	host.animation_player.play("launched")
		
func process_physics(delta):
	host.velocity.y += host.gravity * host.gravity_modifier
	host.velocity.x = lerp(host.velocity.x, 0.0, host.drag * delta)
		
func physics_process(delta):
	process_physics(delta)
	if host.grounded():
		if host.hard_knockdown:
			return "HardKnockdown"
		else:
			return "Knockdown"
	return process_input()
