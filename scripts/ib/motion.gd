extends Resource
class_name Motion

@export var steps : Array[FGInput]
@export var duration := 0
@export var charge_axis := {"x" : 0, "y" : 0}

func read_buffer(buffer : Array, flipped):
	var passes = 0
	var success = false 
	
	for i in range(0, steps.size()):
		if passes >= steps.size():
			success = true
			break
		var elapsed = 0
		for input in buffer:
			elapsed += 1
			if elapsed > duration:
				break
			var axis = input.axis 
			var buttons = input.buttons
			if flipped:
				axis.x *= -1
			
			if call("pass_"+str(i), input):
				passes += 1
				continue
			if axis.x != steps[i].axis.x and axis.y != steps[i].axis.y:
				continue
			if buttons.hash() != steps.hash():
				continue
				
			passes += 1
			break
		if elapsed > duration:
			break
	
	return success
	
func check_charge(axis, time : int, delay : int):
	if axis.x == charge_axis.x and axis.y == charge_axis.y:
		return true 
	return false
