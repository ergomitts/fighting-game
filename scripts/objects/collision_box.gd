@tool
extends Node2D
class_name CollisionBox

@export var host : Node

@export var active := true
@export var shape := Rect2(-64, -64, 128, 128)
@export var type : GameConstants.CollisionType

@export var center := false : set = _self_center
@export var flipped := false : set = _flip

func _ready():
	host = get_parent()

func _init():
	z_index = 99
	z_as_relative = false
	
func is_colliding_with(other: CollisionBox) -> int:
	var my_box := get_global_rect()
	var other_box := other.get_global_rect()
	
	if my_box.intersects(other_box):
		return int(my_box.intersection(other_box).size.x)
	return 0
	
func get_center() -> Vector2:
	return shape.get_center() + global_position

func get_global_rect() -> Rect2:
	return Rect2(global_position + shape.position, shape.size)

func _self_center(value):
	shape.position = -shape.size/2

func _flip(value):
	flipped = value
	var right := shape.position.x + shape.size.x
	shape.position.x = -right

func can_draw() -> bool:
	if Engine.is_editor_hint() or true:
		return active
	return false	

func draw_box():
	if can_draw():
		var color = GameConstants.CollisionColors.get(type, GameConstants.CollisionType.Hit)
		draw_rect(shape, color, false)
		draw_rect(shape, Color(color, 0.3), true)

func _process(_delta: float):
	queue_redraw()
func _draw():
	draw_box()
