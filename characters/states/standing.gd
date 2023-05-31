extends GroundedState
class_name StandState

func enter():
<<<<<<< HEAD
	if !host.animation_player.current_animation == "crouching_exit":
=======
	host.crouching = false
	if !host.animation_player.current_animation == "crouching_exit" and !host.animation_player.current_animation == "landing":
>>>>>>> dev
		host.animation_player.play("standing")

func process_input():
	var state = super.process_input()
	if state and state != "Standing":
		return state
	
	var controller := InputManager.controllers[host.id - 1] as Controller
<<<<<<< HEAD
	var axis = controller.get_axis()

=======
>>>>>>> dev
	var grab_combo = controller.check_combined_buttons(["light", "medium"])
	if grab_combo:
		return "Grab"
