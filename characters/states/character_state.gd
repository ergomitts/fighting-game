extends State
class_name CharacterState

func get_input() -> FGInput:
	var controller = InputManager.controllers[host.id - 1]
	var _input = controller.buffer[controller.BUFFER_FRAMES - 1]
	return _input
func get_axis() -> Vector2:
	var controller = InputManager.controllers[host.id - 1]
	return controller.get_axis()
func get_buttons() -> Dictionary:
	var controller = InputManager.controllers[host.id - 1]
	return controller.get_buttons()
func get_flipped() -> int:
	return -1 if host.flipped else 1
func get_dir() -> int:
	var axis = get_axis()
	var dir = axis.x * get_flipped()
	return dir
func is_pressing(button := "") -> bool:
	var controller = InputManager.controllers[host.id - 1]
	return controller.is_pressing(button)
func is_holding_away():
	var axis = get_axis()
	var dir = host.get_flipped()
	if axis.x * dir == -1:
		return true
	return false
		
func on_hit(attack: ActionState):
	if (is_holding_away() or host.autoblock) and host.defense.value > 0 and attack.attack_type != Constants.AttackType.Unblockable and name != "Launched" and name != "Stunned" and name != "Grabbed" and name != "HardKnockdown" and self is ActionState == false:
		var axis = get_axis()
		var crouching = axis.y == 1
		var low = crouching and attack.attack_type != Constants.AttackType.High
		var high = !crouching and attack.attack_type != Constants.AttackType.Low
		var air = !host.grounded() and attack.attack_type != Constants.AttackType.AirUnblockable
		if host.autoblock and attack.attack_type != Constants.AttackType.Medium:
			host.crouching = attack.attack_type == Constants.AttackType.Low
		if low or high or air or host.autoblock:
			return "Blocking"
	if attack.launch_on_hit or !host.grounded():
		return "Launched"
	elif name != "Knockdown":
		if attack.force_stance == "Standing":
			host.crouching = false
		elif attack.force_stance == "Crouching":
			host.crouching = true
		return "Stunned"
	
func get_attack_state(motion_input, axis := Vector2.ZERO):
	var state := ""
	var pressing := -1
	if is_pressing("special"):
		pressing = Constants.Buttons.Special
	elif is_pressing("heavy"):
		pressing = Constants.Buttons.Heavy
	elif is_pressing("medium"):
		pressing = Constants.Buttons.Medium
	elif is_pressing("light"):
		pressing = Constants.Buttons.Light

	for attack_name in host.attack_states:
		var i = host.get_attack_state(attack_name)
		if i.motion == motion_input and (i.button == pressing or (i.can_special and pressing == Constants.Buttons.Special)) and host.special.value >= i.meter_usage:
			if i.motion == Constants.MotionInput.Empty:
				var dir := axis
				dir.x *= host.get_flipped()
				if i.direction != dir and i.direction != Vector2.ZERO:
					continue
				elif i.direction == Vector2.ZERO and (axis.y == 1) != i.crouch:
					continue
			if (host.grounded() and i.ground) or (!host.grounded() and i.aerial):
				state = i.name
				InputManager.controllers[host.id - 1].clear()
				break
			
	return state
	
func process_input():
	var controller := InputManager.controllers[host.id - 1] as Controller
	var axis = get_axis()
	
	var grab_combo = controller.check_combined_buttons(["light", "medium"])
	if grab_combo and (name == "Standing" or name == "Walking" or name == "Running"):
		return "Grab"
	
	var buttons = get_buttons()
	
	if buttons.size() > 0:
		var motion_input
		for i in range(Constants.MotionInput.size()):
			var motion = controller.read_motion_input(i, host.flipped)
			if motion:
				motion_input = i
				break
		if motion_input:
			var state = get_attack_state(motion_input, axis)
			if state:
				return state
		
		if controller.read_directional_input(Vector2.LEFT, "special", host.flipped) or controller.read_directional_input(Vector2.DOWN + Vector2.LEFT, "special", host.flipped):
			return get_attack_state(Constants.MotionInput.QuarterCircleB)
		elif controller.read_directional_input(Vector2.RIGHT, "special", host.flipped):	
			return get_attack_state(Constants.MotionInput.QuarterCircleF)
		elif controller.read_directional_input(Vector2.DOWN + Vector2.RIGHT, "special", host.flipped):	
			return get_attack_state(Constants.MotionInput.DragonPunch)
		elif controller.read_directional_input(Vector2.DOWN, "special", host.flipped):
			return get_attack_state(Constants.MotionInput.HalfCircleF)

func process_physics(delta):
	if !host.grounded():
		host.velocity.y += host.gravity
	else:
		host.velocity.x = lerp(host.velocity.x, 0.0, host.friction * delta)
		host.velocity.y = 0		
		
func physics_process(delta):
	process_physics(delta)
	return process_input()
