tool
extends Node2D
class_name CollisionBox

var host

export var active := true
export var shape := Rect2(-10, -10, 20, 20)
export var color := Color.red

func _ready():
	host = get_owner()

func _init():
	z_index = 99
	z_as_relative = false
	
func is_colliding(_shape: Rect2):
	return active and get_global_rect().intersects(_shape)
	
func get_center() -> Vector2:
	return (shape.position + global_position)/2
	
func get_global_rect() -> Rect2:
	return Rect2(shape.position + global_position, shape.size)

func can_draw() -> bool:
	if Engine.editor_hint or GameGlobals.get('DEBUGGING'):
		return active
	return false

func draw_box():
	draw_rect(shape, color, false)
	draw_rect(shape, Color(color.r, color.g, color.b, 0.2), true)

func up_global() -> int:
	return int(global_position.y + shape.position.y)
	
func down_global() -> int:
	return int(global_position.y + shape.position.y + shape.size.y)

func left_global() -> int:
	return int(global_position.x + shape.position.x)
	
func right_global() -> int:
	return int(global_position.x + shape.position.x + shape.size.x)
	
func up() -> int:
	return int(shape.position.y)
	
func down() -> int:
	return int(shape.position.y + shape.size.y)

func left() -> int:
	return int(shape.position.x)
	
func right() -> int:
	return int(shape.position.x + shape.size.x)

func _process(delta: float):
	update()
	
func _draw():
	if can_draw():
		draw_box()
