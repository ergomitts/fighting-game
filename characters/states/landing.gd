extends CharacterState

func enter():
	host.animation_player.play("Landing")
	host.velocity.x = 0
	host.velocity.y = 0
	
func physics_process(delta):
	if host.animation_finished():
		return "Idle"
