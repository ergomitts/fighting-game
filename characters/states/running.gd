extends GroundedState

<<<<<<< HEAD
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
=======
var started := false
var stopped := false
var dir := Vector2.ZERO

func enter():
	started = false
	stopped = false
	host.face_target()
	host.animation_player.play("running_start")
	dir = Vector2.ZERO
	dir.x = get_axis().x
	host.sprite_container.get_node("DashParticle").emitting = true

func exit():
	host.face_target()
	host.punishable = false
	host.sprite_container.get_node("DashParticle").emitting = false
	
func physics_process(delta):
	if !started:
		started = host.animation_finished()
		host.velocity.x = host.forward_walk_speed * host.get_flipped()
	elif !stopped:
		host.animation_player.play("running")
		var state = process_input()
		if state != "Walking" and state != "Running" and state != "Standing" and state != "Crouching":
			return state
		var axis = get_axis()
		if axis.x != dir.x or axis.x == 0:
			stopped = true
			host.animation_player.play("running_end")
		host.velocity.x = dir.x * host.run_speed
	elif stopped:
		host.velocity.x = lerp(host.velocity.x, 0.0, host.friction * delta)
		host.punishable = true
		host.sprite_container.get_node("DashParticle").emitting = false
		var state = process_input()
		if state in host.attack_states:
			return state
		if host.animation_finished():
			return "Grounded"
>>>>>>> dev
	
