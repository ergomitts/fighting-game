tool
extends Node2D
class_name MultiCollisionBox

var host

export var active := false
export(Array, Rect2) var anim_shapes setget update_shapes
export(Color) var color
export(bool) var flipped setget flip

var shapes := []

func _ready():
	host = get_owner()

func _init():
	z_index = 99
	z_as_relative = false

func get_collisions(collision):
	if !active:
		return
		
	var hit := false
	var	hit_position := Vector2.ZERO
	
	for shape in shapes:
		var global_rect = Rect2(shape.position + global_position, shape.size)
		for _shape in collision.shapes:
			var _shape_rect = Rect2(_shape.position + collision.global_position, _shape.size)
			if global_rect.intersects(_shape_rect): 
				var clip : Rect2 = global_rect.clip(_shape_rect)
				hit_position = Vector2(clip.position.x - clip.size.x/2, clip.position.y - clip.size.y/2)
				hit = true
				break
		if hit: 
			break
			
	return {'hit' : hit, 'position' : hit_position}

func update_shapes(value):
	anim_shapes = value
	shapes = value.duplicate()
	flip(flipped)

func flip(value):
	flipped = value
	if flipped:
		for shape in shapes:
			var right = shape.position.x + shape.size.x
			shapes[shapes.find(shape)].position.x = -right
	else:
		shapes = anim_shapes.duplicate()

func can_draw() -> bool:
	if Engine.editor_hint or GameGlobals.get('DEBUGGING'):
		return active
	return false

func draw_box(shape: Rect2):
	draw_rect(shape, color, false)
	draw_rect(shape, Color(color.r, color.g, color.b, 0.2), true)

func _process(delta: float):
	update()
	
func _draw():
	if can_draw():
		for shape in shapes:
			if shape is Rect2:
				draw_box(shape)
