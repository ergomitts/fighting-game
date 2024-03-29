extends GameObject
class_name CharacterObject

@export_category("Nodes")
@export var state_machine : StateMachine
@export var health : Node
@export var defense : Node
@export var special : Node
@export var effects : Node
@export var projectiles : Node
@export var attack_states : Array[String] = []

@export var push_box : PushBox
@export var hurt_box : CollisionBox
@export var hit_box : CollisionBox

@export_category("Settings")
@export var forward_walk_speed := 15.0
@export var backward_walk_speed := 13.0
@export var jump_velocity := 70.0
@export var leap_speed := 18.0
@export var run_speed := 35.0
@export var back_dash_velocity := 24.0
@export var friction := 10.0
@export var drag := 2.0
@export var default_gravity := 5.0
@export var gravity := default_gravity
@export var gravity_modifier := 1.0

@export_category("Properties")
@export var immune := false
@export var grab_immune := false
@export var projectile_immune := false
@export var counterable := false
@export var punishable := false
@export var crouching := false
@export var hard_knockdown := false
@export var max_jumps := 4

@export_category("Cheats")
@export var autoblock := false

var id := 0
var nemesis : CharacterObject

var hit_confirmed := false
var jumps := max_jumps
var jump_dir := 0
var hitstun := 0

func _ready():
	state_machine.init()
	if id == 2:
		sprite_container.get_node("Main").material.set_shader_parameter("main_color", Color(0.4, 0.6, 1.0, 1.0))

func is_dead():
	return health.value <= 0

func get_input() -> FGInput:
	var controller = InputManager.controllers[id - 1]
	var input = controller.buffer[controller.BUFFER_FRAMES - 1]
	return input
func get_axis() -> Vector2:
	var controller = InputManager.controllers[id - 1]
	return controller.get_axis()
func get_buttons() -> Dictionary:
	var controller = InputManager.controllers[id - 1]
	return controller.get_buttons()
func get_dir() -> int:
	var axis = get_axis()
	var dir = axis.x * get_flipped()
	return dir
func is_pressing(button := "") -> bool:
	var controller = InputManager.controllers[id - 1]
	return controller.is_pressing(button)

func get_flipped():
	return -1 if flipped else 1

func get_corner():
	var rect := push_box.get_global() as Rect2
	var pos := rect.position.x
	var size := rect.size.x
	if pos <= Globals.limit_left:
		return -1
	if pos + size >= Globals.limit_right:
		return 1
	return 0

func in_corner():
	var rect := push_box.get_global() as Rect2
	var pos := rect.position.x
	var size := rect.size.x
	return pos <= Globals.limit_left or pos + size >= Globals.limit_right
	
func grounded():
	var rect := push_box.get_global() as Rect2
	return rect.position.y + rect.size.y >= Globals.StageBottom
	
func get_attack_state(attack_name):
	return state_machine.get_node(attack_name)
	
func animation_finished():
	return animation_player.current_animation_position >= animation_player.current_animation_length

func animation_pos_in_frames():
	if animation_player.current_animation:
		return int(animation_player.current_animation_position * 60.0)
	return 0
	
func animation_length_in_frames():
	if animation_player.current_animation:
		return int(animation_player.current_animation_length * 60.0)
	return 0
	
func face_target():
	if global_position.x > nemesis.global_position.x:
		flipped = true
	else:
		flipped = false
	hurt_box.flipped = flipped
	hit_box.flipped = flipped
	
func on_hit(attack: ActionState):
	if state_machine.state.has_method("on_hit"):
		return state_machine.state.call("on_hit", attack)
	
func physics_process(delta):
	if hitstun > 0:
		hitstun -= 1
	defense.update(delta)	
	state_machine.update_state("physics_process", delta)
	move(velocity)
	
