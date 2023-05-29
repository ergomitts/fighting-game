extends ActionState

func enter():
	hits = hit_amount
	frame = 0
	host.face_target()
	host.animation_player.stop()
	host.animation_player.play("burst")
	host.velocity.x = 0.0
	host.velocity.y = -10.0
	host.gravity = 0.0
	host.counterable = false
	host.punishable = false
	host.crouching = false
	host.hard_knockdown = false
	host.hitstun = 0

func exit():
	host.gravity = host.default_gravity
	
func physics_process(delta):
	if frame >= startup_frames + active_frames:
		host.gravity = host.default_gravity
	process_physics(delta)
	if host.grounded():
		return "Landing_Burst"
	if frame >= startup_frames + active_frames:
		host.counterable = false
		host.punishable = true
	frame += 1
