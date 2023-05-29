extends CharacterState

@export var clash_window := 10
var frames := 0
var timeout := 0

func enter():
	frames = clash_window
	host.face_target()
	host.animation_player.play("grabbed")
	host.global_position = host.nemesis.sprite_container.get_node("GrabPosition").global_position
	host.projectile_immune = true
	host.grab_immune = true
	timeout = 200
	
func exit():
	host.projectile_immune = false
	host.grab_immune = false
	
func physics_process(delta):
	if frames > 0:
		frames -= 1
		var controller := InputManager.controllers[host.id - 1] as Controller
		var grab_combo = controller.check_combined_buttons(["light", "medium"])
		if grab_combo:
			host.nemesis.state_machine.change_state("ThrowClash")
			return "ThrowClash"
	host.global_position = host.nemesis.sprite_container.get_node("GrabPosition").global_position
	host.face_target()
	if timeout > 0:
		timeout -= 1
	elif timeout == 0:
		return "Grounded" if host.grounded() else "Aerial"
	
