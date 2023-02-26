extends Node
class_name StateMachine

export(String) var init_state

var host
var active = false setget set_active

var state_map := {}
var state_stack := []

var current_state

signal state_changed(state)

func init(state):
	host = host if host != null else get_parent()
	
	for _state in get_children():
		state_map[_state.name] = _state
		_state.host = host

	active = true
	change_state(state)
	
func set_active(value):
	set_physics_process(value)
	set_process(value)
	set_process_input(value)
	if !value:
		state_stack.clear()
		current_state = null

func change_state(state: String):
	if state == '!previous':
		state_stack.pop_front()
	else: 
		var _state = state_map.get(state, null)
		if _state:
			state_stack.push_front(_state)
			
	if current_state == state_stack[0]:
		return

	if current_state != null:
		current_state.exit()
		
	current_state = state_stack[0]
	current_state.enter()
	emit_signal('state_changed', current_state.name)

func _transition_state(event: String, arg = null):
	if !active:
		return
	var _state = current_state.call(event, arg)
	if _state:
		change_state(_state)

func _process(delta: float) -> void:
	_transition_state('process', delta)
	
func _physics_process(delta: float) -> void:
	_transition_state('physics_process', delta)
	
func _input(event: InputEvent) -> void:
	_transition_state('input', event)
