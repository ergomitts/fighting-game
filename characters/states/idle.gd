extends CharacterState

@export var animation := "standing"
var landed := false

func enter():
	landed = false
	host.face_target()
	host.jumps = host.max_jumps
	host.immune = false
	host.grab_immune = false
	host.projectile_immune = false
	host.counterable = false
	host.punishable = false
	host.crouching = false
	host.hard_knockdown = false
	host.hit_confirmed = false
	host.hitstun = 0
	
func process_physics(delta):
	host.velocity.y += host.gravity * host.gravity_modifier
	host.velocity.x = lerp(host.velocity.x, 0.0, host.drag * delta)
		
func physics_process(delta):
	process_physics(delta)
	if host.grounded():
		if !landed:
			landed = true 
			host.animation_player.play(animation)
