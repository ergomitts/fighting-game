extends Node2D
class_name GameObject

@export var sprite_container : Marker2D
@export var animation_player : AnimationPlayer

var hitstop : int = 0
var velocity : Vector2
var facing : int = 1: set = _set_facing

func move(dir: Vector2):
	position = Vector2i(position + dir)

func _set_facing(value: int = 1):
	if abs(value) > 0:
		facing = value
		sprite_container.scale.x = value
		
func _update_physics(delta: float):
	pass
func _physics_process(delta: float):
	if hitstop > 0:
		hitstop -= 1 
	else:
		_update_physics(delta)
