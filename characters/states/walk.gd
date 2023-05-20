extends GroundedState
class_name WalkState

func enter():
	host.face_target()
	host.animation_player.play("Walk")

func exit():
	host.face_target()
	host.velocity.x = 0	
	
func physics_process(delta):
	var axis = get_axis()
	var speed = host.forward_walk_speed
	var dir = get_dir()
	if dir < 0:
		speed = host.backward_walk_speed
	host.velocity.x = axis.x * speed
	return process_input()
	
