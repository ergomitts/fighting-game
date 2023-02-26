extends Node2D
class_name GameObject

var hitstop := 0
	
func move(velocity):
	position.x += int(floor(abs(velocity.x))) * sign(velocity.x)
	position.y += int(floor(abs(velocity.y))) * sign(velocity.y)

func update_physics(delta: float):
	pass

func _physics_process(delta: float):
	if hitstop > 0:
		hitstop -= 1
	else:
		update_physics(delta)
