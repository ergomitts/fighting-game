extends Node
class_name StateMachine

@export var host : Node
@export var default_state : String
@export var state_map : Dictionary = {}

var active := false : set = _set_active

var state : State
var _stack : Array[State] = []

signal state_changed(state_name: String)

func _set_active(value: bool):
	active = value
	set_physics_process(value)
	set_process(value)
	set_process_input(value)
	if !value:
		_stack.clear()
	
func init(init_state: String = default_state):
	host = host if host != null else get_parent()
	
	for state_name in state_map:
		if state_map[state_name] is State:
			state_map[state_name].init(host)
	
	for child in get_children():
		if state_map.has(child.name):
			continue
		if child is State:
			state_map[child.name] = child
			child.init(host)
	
	active = true
	change_state(init_state)
	
func change_state(state_name: String):
	if state_name == ".previous":
		_stack.pop_front()
	else: 
		var new_state = state_map.get(state_name, null)
		if new_state:
			_stack.push_front(new_state)
			
	if state == _stack[0]:
		return

	if state != null:
		state.exit()
		
	state = _stack[0]
	state.enter()
	emit_signal("state_changed", state.name)

func _update_state(event: String, arg = null):
	if active:
		var new_state = state.call(event, arg)
		if new_state:
			change_state(new_state)
			
func _process(delta: float) -> void:
	_update_state("process", delta)
func _physics_process(delta: float) -> void:
	_update_state("physics_process", delta)
func _input(event: InputEvent) -> void:
	_update_state("input", event)

