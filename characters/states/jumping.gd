extends AerialState

var started_straight := false
var frame := 0

func enter():
	var axis = get_axis()
	host.animation_player.play("jumping")
	if host.velocity.x == 0.0:
		host.velocity.x = host.jump_dir * host.leap_speed
		host.jump_dir = 0
	host.velocity.y = -host.jump_velocity
	started_straight = axis.x == 0
	frame = 5

func physics_process(delta):
	var state = super.physics_process(delta)
	if frame == 0:
		if state:
			return state
	
	if host.grounded():
		return "Landing"
	elif host.velocity.y > 0:
		return "Aerial"
		
	if frame > 0:
		frame -= 1
		
		
