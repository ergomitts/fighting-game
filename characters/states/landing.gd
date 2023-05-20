extends CharacterState

@export var frames := 2
var time := 0

func enter():
	host.animation_player.play("Landing")
	time = 0
	
func physics_process(delta):
	time += 1
	if time >= frames:
		return "Grounded"
