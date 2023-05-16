extends CharacterState
class_name JumpState

func enter():
	host.velocity.x = 0
	
	if name == "Prejump":
		host.animation_player.play("Prejump")
	else:
		var axis = get_axis()
		var speed = host.forward_walk_speed
		var dir = axis.x * (-1 if host.flipped else 1)
		if dir < 0:
			speed = host.backward_walk_speed
		host.animation_player.play("Jump")
		host.velocity.x = axis.x * speed
		host.velocity.y = -host.jump_velocity
	
	
func physics_process(delta):
	super.physics_process(delta)
	if name == "Prejump":
		if host.animation_finished():
			return "Jumping"
	else:
		if host.grounded():
			return "Landing"
