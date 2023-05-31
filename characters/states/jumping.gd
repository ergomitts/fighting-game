extends AerialState

var started_straight := false
var frame := 0

func enter():
	var axis = get_axis()
<<<<<<< HEAD
	var speed = host.forward_walk_speed
	var dir = axis.x * (-1 if host.flipped else 1)
	if dir < 0:
		speed = host.backward_walk_speed
	host.animation_player.play("jumping")
	host.velocity.x = axis.x * speed
=======
	var dir = axis.x * (-1 if host.flipped else 1)
	host.animation_player.play("jumping")
	if host.velocity.x != 0:
		host.velocity.x *= dir
	else:
		host.velocity.x = host.jump_dir * host.leap_speed
		host.jump_dir = 0
>>>>>>> dev
	host.velocity.y = -host.jump_velocity
	started_straight = axis.x == 0
	frame = 5

func physics_process(delta):
<<<<<<< HEAD
	if started_straight:
		var axis = get_axis()
		var speed = host.forward_walk_speed
		var dir = axis.x * (-1 if host.flipped else 1)
		if dir < 0:
			speed = host.backward_walk_speed
		host.velocity.x = axis.x * speed
	
=======
>>>>>>> dev
	var state = super.physics_process(delta)
	if state and frame == 0:
		return state
	
	if host.grounded():
		return "Landing"
	elif host.velocity.y > 0:
		return "Aerial"
		
	if frame > 0:
		frame -= 1
		
		
