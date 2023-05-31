@tool
extends Node2D
class_name CollisionBox

var color := Color.BLUE_VIOLET

@export var active := true
@export var flipped := false : set = _flip
<<<<<<< HEAD
@export var data : Array[Rect2] = [] : set = _update

var _flipped_data := []
var _data := []
var _modified := false
=======
@export var data : Array = [] : set = _update

var flipped_data := []
var data_meat := []
var modified := false
>>>>>>> dev
	
func _init():
	z_index = 99
	z_as_relative = false

func _flip(value):
	if Engine.is_editor_hint():
		return
	flipped = value
<<<<<<< HEAD
	if flipped and !_modified:
		_modified = true
		_data = _flipped_data
	elif !flipped and _modified:
		_modified = false
		_data = data

func _update(value):
	data = value
	_data = value
	if Engine.is_editor_hint():
		return
	_flipped_data.clear()
	_modified = false
	for i in range(0, value.size()):
		_flipped_data.append(Rect2(Vector2(-(value[i].position.x + value[i].size.x), value[i].position.y), value[i].size))
	if flipped:
		_flip(true)
=======
	if flipped and !modified:
		modified = true
		data_meat = flipped_data
	elif !flipped and modified:
		modified = false
		data_meat = data
	return value

func _update(value):
	data = value
	data_meat = value
	if Engine.is_editor_hint():
		return
	flipped_data.clear()
	modified = false
	for i in range(0, value.size()):
		flipped_data.append(Rect2(Vector2(-(value[i].position.x + value[i].size.x), value[i].position.y), value[i].size))
	if flipped:
		_flip(true)
	return value
>>>>>>> dev
		
func clear():
	data.clear()
	
func get_boxes():
<<<<<<< HEAD
	return _data
=======
	return data_meat
>>>>>>> dev
	
func check_collision(other : CollisionBox):
	var my_boxes = get_boxes()
	var other_boxes = other.get_boxes()
	var hit := false
	var pos := Vector2.ZERO
	for i in my_boxes:
		var i_r = Rect2(global_position + i.position, i.size)
		for x in other_boxes:
			var x_r = Rect2(other.global_position + x.position, x.size)
			if i_r.intersects(x_r):
				hit = true
				pos = i_r.intersection(x_r).get_center()
				break
	if hit:
		return pos

func draw_collisions():
<<<<<<< HEAD
	for rect in _data:
		draw_rect(rect, color, false)
	#	draw_rect(rect, Color(color, 0.2), true)
=======
	for rect in data_meat:
		draw_rect(rect, color, false)
		draw_rect(rect, Color(color, 0.1), true)
>>>>>>> dev
		
func _process(_delta: float):
	queue_redraw()
func _draw():
	if Engine.is_editor_hint() or Globals.debug:
		draw_collisions()
