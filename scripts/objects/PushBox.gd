tool
extends CollisionBox
class_name PushBox

export(bool) var make_centered setget self_center

func _init():
	color = Color.yellow
	
func self_center(value):
	shape.position = -shape.size/2
	
func get_corner(offset := 0.0):
	var side = 0
	if right_global() + offset >= GameGlobals.get('StageRight'):
		side = 1
	elif left_global() + offset <= GameGlobals.get('StageLeft'):
		side = -1
	return side
	
func move_and_push(velocity: Vector2, push_box = null) -> Vector2:
	var up = up_global() + velocity.y
	var down = down_global() + velocity.y
	
	if down > GameGlobals.get('StageBottom'):
		velocity.y -= down - GameGlobals.get('StageBottom')
	elif up < GameGlobals.get('StageTop'):
		velocity.y -= up - GameGlobals.get('StageTop')
		
	if get_corner(velocity.x) == 1:
		velocity.x -= right_global() + velocity.x - GameGlobals.get('StageRight')
	elif get_corner(velocity.x)	== -1:
		velocity.x -= left_global() + velocity.x - GameGlobals.get('StageLeft')		
		
	var moved_box = Rect2(get_center() + velocity, shape.size)
	if push_box and moved_box.intersects(push_box.get_global_rect()):
		push_box.host.move(push_box.move_and_push(Vector2(velocity.x, 0)))	
		
		var center = moved_box.position.x + moved_box.size.x/2
		if center > push_box.global_position.x or push_box.get_corner() == -1:
			velocity.x -= left_global() + velocity.x - push_box.right_global()
		elif center < push_box.global_position.x or push_box.get_corner() == 1:
			velocity.x -= right_global() + velocity.x - push_box.left_global()
			
		var corner = get_corner(velocity.x)	
		if corner == 1:
			velocity.x -= right_global() + velocity.x - GameGlobals.get('StageRight')
			push_box.host.move(push_box.move_and_push(Vector2(left_global() + velocity.x - push_box.right_global(), 0)))
		elif corner == -1:
			velocity.x -= left_global() + velocity.x - GameGlobals.get('StageLeft')	
			push_box.host.move(push_box.move_and_push(Vector2(right_global() + velocity.x - push_box.left_global(), 0)))
				
	return velocity
