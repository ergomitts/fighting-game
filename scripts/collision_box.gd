@tool
extends Node2D
class_name CollisionBox

var color := Color.BLUE_VIOLET

@export var active := true
@export var flipped := false : set = _flip
@export var data : Array[Rect2i] = [] : set = _update

var _flipped_data := []
var _data := []
var _modified := false
	
func _init():
	z_index = 99
	z_as_relative = false

func _flip(value):
	flipped = value
	if flipped and !_modified:
		_modified = true
		_data = _flipped_data
	elif !flipped and _modified:
		_modified = false
		_data = data

func _update(value):
	data = value
	_data = value
	_flipped_data.clear()
	_modified = false
	for i in range(0, value.size()):
		_flipped_data.append(Rect2i(Vector2(-(value[i].position.x + value[i].size.x), value[i].position.y), value[i].size))
	if flipped:
		_flip(true)

func draw_collisions():
	for rect in _data:
		draw_rect(rect, color, false)
		draw_rect(rect, Color(color, 0.3), true)
		
func _process(_delta: float):
	queue_redraw()
func _draw():
	if Engine.is_editor_hint() or Globals.debug:
		draw_collisions()
