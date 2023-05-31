extends ActionState

var landed := false

func enter():
	landed = false
	hits = hit_amount
	frame = 0
	host.animation_player.stop()
	host.animation_player.play(animation)
	host.counterable = true
	host.punishable = false
	host.special.use(meter_usage)
	if !host.hit_confirmed and host.grounded():
		host.velocity.x = 0.0
	host.hit_confirmed = false
	host.crouching = crouch
	host.velocity.x = 0.0
	host.velocity.y = 0.0
	if host.in_corner():
		host.position.x += -(host.push_box.shape.size.x) * host.get_corner()
	host.sprite_container.get_node("LaunchParticle").emitting = true
	
func exit():
	host.sprite_container.get_node("LaunchParticle").emitting = false
	
func physics_process(delta):
	if frame > startup_frames + active_frames and !landed:
		process_physics(delta)
		if host.grounded():
			host.animation_player.play("buster_end")
			host.velocity.y = 0.0
			landed = true
			host.sprite_container.get_node("LaunchParticle").emitting = false
	elif frame > startup_frames and !landed:
		host.velocity.y = -60.0
	
	if landed and host.animation_finished():
		return "Grounded"
		
	frame += 1			
	
	
