@tool
extends Node2D
class_name CollisionGroup

@export var host : Node

@export var active := true : set = _set_active
@export var type : GameConstants.CollisionType : set = _update_type

@export var max_collisions := 5 : set = _init_group
@export var group : Array[Rect2] = [] : set = _update_group
@export var flipped := false : set = _flip

var _group : Array[CollisionBox]

func _ready():
	host = get_parent()
	
func _init():
	z_index = 99
	z_as_relative = false
	_init_group(max_collisions)
			
func _init_group(value = 0):
	max_collisions = value
	for box in _group:
		box.active = false
		box.queue_free()
	_group.clear()
	
	for i in range(0, value):
		if not range(_group.size()).has(i):
			var collision_box = CollisionBox.new()
			collision_box.host = host
			collision_box.active = false
			collision_box.type = type
			add_child(collision_box)
			_group.append(collision_box)
	_update_group(group)

func is_colliding_with(other: CollisionBox):
	var hit
	for box in _group:
		var intersection = box.is_colliding_with(other)
		if abs(intersection) > 0:
			hit = other
			break
	return hit
	
func is_colliding_with_group(other: CollisionGroup):
	var hit
	for box in _group:
		for _box in other._group:
			var intersection = box.is_colliding_with(_box)
			if abs(intersection) > 0:
				hit = other
				break
		if hit:
			break
	return hit

func _set_active(value):
	active = value
	for box in _group:
		box.active = value

func _update_type(value):
	type = value 
	for box in _group:
		box.type = value

func _update_group(value: Array):
	group = value
	for i in range(0, max_collisions):
		if !range(_group.size()).has(i):
			continue
		if value.size() - 1 < i:
			_group[i].active = false
			_group[i].shape = Rect2(0, 0, 0, 0)
		else:
			_group[i].active = active
			_group[i].shape = value[i]
			if flipped:
				_group[i].flipped = flipped

func _flip(value):
	flipped = value
	for box in _group:
		if box.active:
			box.flipped = value
