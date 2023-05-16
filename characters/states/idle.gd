extends CharacterState
class_name IdleState

func enter():
	host.animation_player.play("Idle")
	host.face_target()

func physics_process(delta):
	super.physics_process(delta)
	host.face_target()
	return process_input()
