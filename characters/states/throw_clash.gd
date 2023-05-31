extends CharacterState

var frame := 0

func enter():
	host.face_target()
	host.animation_player.play("throw_clash")
	host.velocity.x = -20.0 * host.get_flipped()
	host.velocity.y = 0.0
	frame = 40
	
func exit():
	host.velocity.x = 0.0
	host.face_target()
	
func physics_process(delta):
	host.velocity.x = lerp(host.velocity.x, 0.0, host.friction * delta)
	if frame == 40:
		var height = host.push_box.shape.position.y + host.push_box.shape.size.y
		host.position.y = Globals.StageBottom - height
	if frame > 0:
		frame -= 1
	elif frame <= 0:
		return "Grounded"
	
