extends CharacterState

@export var frames := 2
@export var animation := "landing"
@export var grab_immune := false
var time := 0

func enter():
	host.face_target()
	host.velocity.x = 0 
	host.velocity.y = 0
	host.animation_player.play(animation)
	time = 0
	host.punishable = true
	host.gravity = host.default_gravity
	host.grab_immune = grab_immune
	host.jumps = host.max_jumps
	
func exit():
	host.punishable = false
	host.grab_immune = false
	host.hard_knockdown = false
	
func physics_process(delta):
	host.velocity.y = 0
	time += 1
	if time >= frames:
		return "Grounded"
