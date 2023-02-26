tool
extends CollisionBox
class_name PushBox

export(bool) var make_centered setget self_center

func _init():
	color = Color.yellow
	
func self_center(value):
	shape.position = -shape.size/2
	
func move_and_push(velocity: Vector2, push_box = null) -> Vector2:
	if down_global() > GameGlobals.get('MinY'):
		velocity.y -= down_global() - GameGlobals.get('MinY')
	elif up_global() < GameGlobals.get('MaxY'):
		velocity.y -= up_global() - GameGlobals.get('MaxY')
		
	if push_box and is_colliding(push_box.get_global_rect()):
		if global_position.x > push_box.global_position.x:
			velocity.x -= left_global() - push_box.right_global()
		else:
			velocity.x -= right_global() - push_box.left_global()
	return velocity
