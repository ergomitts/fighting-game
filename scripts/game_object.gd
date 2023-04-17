extends Node2D
class_name GameObject

@export var sprite_container : Marker2D
@export var animation_player : AnimationPlayer

var hitstop := 0
var velocity := Vector2.ZERO
var flipped := false : set = _flip

func move(dir: Vector2):
	position = Vector2i(position + dir)

func _flip(value):
	flipped = value
	if flipped:
		sprite_container.scale.x = -1 if flipped else 1
		
func _update_physics(delta: float):
	pass
func _physics_process(delta: float):
	if hitstop > 0:
		hitstop -= 1 
	else:
		_update_physics(delta)
