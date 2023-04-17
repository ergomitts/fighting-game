@tool
extends CollisionBox
class_name HitBox

@export var can_hit := false

func _init():
	color = Color.RED
