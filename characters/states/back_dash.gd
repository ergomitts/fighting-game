extends GroundedState

var frame := 0

func enter():
	host.face_target()
	host.animation_player.play("back_dash_start")
	host.velocity.x = -host.back_dash_velocity * host.get_flipped()
	frame = 24
	
func exit():
	host.velocity.x = 0.0
	host.face_target()
	
func physics_process(delta):
	host.velocity.x = lerp(host.velocity.x, 0.0, host.friction * delta)
	if frame > 0:
		frame -= 1
	elif frame == 13:
		host.animation_player.play("back_dash_end")
	elif frame <= 0:
		return "Grounded"
	
