extends GameObject
class_name CharacterObject

@export_category("Nodes")
@export var state_machine : StateMachine
@export var health : Node
@export var attack_states : Array[String] = []

@export var push_box : PushBox
@export var hurt_box : CollisionBox
@export var hit_box : CollisionBox

@export_category("Settings")
@export var forward_walk_speed := 15.0
@export var backward_walk_speed := 13.0
@export var jump_velocity := 70
@export var friction := 50
@export var gravity := 5

@export_category("Properties")
@export var immune := false
@export var grab_immune := false
@export var counterable := false
@export var punishable := false

var id := 0
var nemesis : CharacterObject
var stance := Constants.Stance.Normal

var hit_confirmed := false
var hitstun := 0

func _ready():
	state_machine.init()

func get_corner():
	var rect := push_box.get_global() as Rect2
	var position := rect.position.x
	var size := rect.size.x
	if position <= Globals.limit_left:
		return -1
	if position + size >= Globals.limit_right:
		return 1
	return 0

func in_corner():
	var rect := push_box.get_global() as Rect2
	var position := rect.position.x
	var size := rect.size.x
	return position <= Globals.limit_left or position + size >= Globals.limit_right
	
func grounded():
	return global_position.y + push_box.shape.size.y > Globals.StageBottom
	
func get_attack_state(attack_name):
	return state_machine.get_node(attack_name)
	
func animation_finished():
	return animation_player.current_animation_position >= animation_player.current_animation_length
	
func face_target():
	if global_position.x > nemesis.global_position.x:
		flipped = true
	else:
		flipped = false
	hurt_box.flipped = flipped
	hit_box.flipped = flipped
	
func physics_process(delta):
	state_machine.update_state("physics_process", delta)
	move(velocity)
	
