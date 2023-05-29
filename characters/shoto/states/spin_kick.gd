extends ActionState

@export var speed := 20.0
@export var gravity = 0

func enter():
	super.enter()
	host.gravity = gravity
	host.velocity.y = -10.0
	
func exit():
	host.gravity = host.default_gravity
	
func physics_process(delta):
	host.velocity.y = 0.0
	host.velocity.x = speed * (-1 if host.flipped else 1)
	if frame > startup_frames + active_frames + recovery_frames:
		host.animation_player.stop()
		return "Aerial"
	if frame >= startup_frames + active_frames:
		host.counterable = false
		host.punishable = true
	frame += 1
