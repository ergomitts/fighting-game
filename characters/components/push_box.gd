@tool
extends Node2D
class_name PushBox

var color := Color.YELLOW

@export var active := true
@export var can_push := true
@export var shape := Rect2(-32, -32, 64, 64)

func _init():
	z_index = 99
	z_as_relative = false
		
func get_center():
	return global_position + shape.get_center()
	
func get_global():
	return Rect2(global_position + shape.position, shape.size)
		
func draw_collisions():
	draw_rect(shape, color, false)
	draw_rect(shape, Color(color, 0.3), true)
	
func _process(_delta: float):
	queue_redraw()
func _draw():
	if Engine.is_editor_hint() or Globals.debug:
		draw_collisions()
