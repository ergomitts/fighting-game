extends GameObject
class_name CharacterObject

@export var state_machine : StateMachine

@export var push_box : PushBox
@export var hurt_box : CollisionBox
@export var hit_box : CollisionBox

var id := 0
var nemesis := CharacterObject

func in_corner():
	pass
	
func _update_physics(delta):
	var controller = InputManager.controllers[id - 1]
	var input = controller.buffer[controller.BUFFER_FRAMES - 1]
	var dir = input.axis.x
	velocity.x = dir * 50
	move(velocity)
