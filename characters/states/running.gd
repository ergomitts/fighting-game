extends GroundedState

var dir := 0

func enter():
	host.face_target()
	host.animation_player.play("running")
	dir = 0

func exit():
	host.face_target()
	
func physics_process(delta):
	var axis = get_axis()
	var speed = host.run_speed
	host.velocity.x = dir * speed
	if axis.x != 0 and dir == 0:
		dir = axis.x
	elif axis.x != dir:
		return "Standing"
	if axis.y == -1:
		return "Prejump"
	elif axis.x == 0:
		return "Standing"
	return process_input()
	
