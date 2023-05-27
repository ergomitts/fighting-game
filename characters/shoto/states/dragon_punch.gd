extends ActionState

@export var rise_velocity := Vector2(15, 70)
@export var gravity = 3.5

func enter():
	super.enter()
	host.velocity.x = rise_velocity.x * (-1 if host.flipped else 1)
	host.velocity.y = -rise_velocity.y
	host.gravity = gravity
	
func exit():
	host.gravity = host.default_gravity
	
func physics_process(delta):
	process_physics(delta)
	if host.grounded():
		return "Landing_DP"
	frame += 1
