extends CharacterState

var bounces := 0
var landed := false

func enter():
	landed = false
	bounces = 3
	host.animation_player.stop()
	host.animation_player.play("launched")
	host.immune = false
	host.grab_immune = false
	host.projectile_immune = false
	host.counterable = false
	host.punishable = false
	host.crouching = false
	host.hard_knockdown = false
	host.jumps = host.max_jumps
	host.hit_confirmed = false
	host.hitstun = 0
	host.projectiles.clear()
	host.velocity.x = -15.0 * host.get_flipped()
	host.gravity = 2.0
	
func exit():
	host.gravity = host.default_gravity
		
func process_physics(delta):
	host.velocity.y += host.gravity
	if landed:
		host.velocity.x = lerp(host.velocity.x, 0.0, host.drag * delta)
		
func physics_process(delta):
	process_physics(delta)
	if host.grounded():
		if !landed:
			if bounces > 0:
				bounces -= 1
				host.velocity.y = -12 * bounces
				host.gravity += 0.5
				host.animation_player.stop()
				host.animation_player.play("launched")
			else:
				landed = true 
				host.animation_player.play("dead")
