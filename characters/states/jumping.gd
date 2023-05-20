extends AerialState

func enter():
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
	if host.grounded():
		host.velocity.y = 0
		host.velocity.x = 0
		return "Landing"
