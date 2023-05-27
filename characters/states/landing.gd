extends CharacterState

@export var frames := 2
@export var animation := "landing"
var time := 0

func enter():
	host.face_target()
	host.velocity.x = 0 
	host.velocity.y = 0
	host.animation_player.play(animation)
	time = 0
	host.punishable = true
	
func exit():
	host.punishable = false
	
func physics_process(delta):
	time += 1
	if time >= frames:
		return "Grounded"
