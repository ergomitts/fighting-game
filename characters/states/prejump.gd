extends CharacterState

var jump_dir := 0

func enter():
	var axis = get_axis()
	jump_dir = axis.x
	host.animation_player.play("prejump")
	host.grab_immune = true
	if host.jumps > 0:
		host.jumps -= 1
	
func exit():
	host.grab_immune = false
	
func physics_process(delta):
	if host.animation_finished() or !host.grounded():
		host.jump_dir = jump_dir
		return "Jumping"
	
