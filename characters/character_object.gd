extends GameObject
class_name CharacterObject

@export var state_machine : StateMachine
@export var health : Node

@export var push_box : PushBox
@export var hurt_box : CollisionBox
@export var hit_box : CollisionBox

@export var forward_walk_speed := 25.0
@export var backward_walk_speed := 15.0
@export var jump_velocity := 50

@export var gravity := 5

var id := 0
var nemesis : CharacterObject

func _ready():
	state_machine.init()

func in_corner():
	pass
	
func grounded():
	return global_position.y + push_box.shape.size.y > Globals.StageBottom
	
func animation_finished():
	return animation_player.current_animation_position >= animation_player.current_animation_length
	
func face_target():
	if global_position.x > nemesis.global_position.x:
		flipped = true
	else:
		flipped = false
	
func physics_process(delta):
	move(velocity)
