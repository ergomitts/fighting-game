extends ActionState

@export var speed := 20.0
@export var rise_speed := 0.0
@export var gravity = 0

func enter():
	super.enter()
	host.gravity = gravity
	host.velocity.y = -rise_speed
	host.position.y -= 10
	
func exit():
	host.gravity = host.default_gravity
	
func physics_process(delta):
	host.velocity.x = speed * (-1 if host.flipped else 1)
	if frame > startup_frames + active_frames + recovery_frames:
		host.animation_player.stop()
		host.animation_player.play("falling")
		host.gravity = host.default_gravity
		process_physics(delta)
		if host.grounded():
			return "Landing_SpinKick"
	if frame >= startup_frames + active_frames:
		host.counterable = false
		host.punishable = true
	frame += 1
