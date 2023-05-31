extends ActionState

@export var rise_velocity := Vector2(15, 70)
@export var gravity = 3.5
@export var startup_frame := 9

var start := 0

func enter():
	super.enter()
	host.gravity = gravity
	host.velocity.x = 0.0
	host.velocity.y = 0.0
	start = 0
	
func exit():
	host.gravity = host.default_gravity
	
func physics_process(delta):
	if start == startup_frame:
		host.velocity.x = rise_velocity.x * (-1 if host.flipped else 1)
		host.velocity.y = -rise_velocity.y
		start = startup_frame + 1
	elif start < startup_frame:
		start += 1
	else:
		process_physics(delta)
		if host.grounded():
			return "Landing_DP"
	if frame >= startup_frames + active_frames:
		host.counterable = false
		host.punishable = true
	frame += 1
