extends Node2D
class_name GameObject

var hitstop := 0

func move_x(amount):
	position.x += int(amount)
	
func move_y(amount):
	position.y += int(amount)

func update_physics(delta):
	pass

func _physics_process(delta: float):
	if hitstop > 0:
		hitstop -= 1
	else:
		update_physics(delta)
