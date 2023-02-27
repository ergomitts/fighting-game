tool
extends CollisionBox
class_name PushBox

export(bool) var make_centered setget self_center

func _init():
	color = Color.yellow
	
func self_center(value):
	shape.position = -shape.size/2

