extends Sprite2D

@export var player1 : Node2D
@export var player2 : Node2D

func stage_clip(pos : Vector2):
	var clip_x = 0
	var clip_y = 0
	if pos.x - 64 < get_parent().left:
		clip_x = get_parent().left - (pos.x - 64)
	elif pos.x + 64 > get_parent().right:
		clip_x = get_parent().right - (pos.x + 64)
	if pos.y + 64 > 500:
		clip_y = 500 - (pos.y + 64)
	return Vector2(clip_x, clip_y)

func _physics_process(delta):
	var p1_rect = Rect2(Vector2(player1.global_position.x - 64, player1.global_position.y - 64), Vector2(128, 128))
	var p2_rect = Rect2(Vector2(player2.global_position.x - 64, player2.global_position.y - 64), Vector2(128, 128))
	if p1_rect.intersects(p2_rect):
		var clip = p1_rect.intersection(p2_rect).size.x
		if player1.global_position.x < player2.global_position.x:
			clip = -clip
		player1.global_position.x += clip/2
		player2.global_position.x -= clip/2

	var p1_clip = stage_clip(player1.global_position)
	var p2_clip = stage_clip(player2.global_position)
	player1.global_position += p1_clip
	player2.global_position += p2_clip
	p1_rect = Rect2(Vector2(player1.global_position.x - 64, player1.global_position.y - 64), Vector2(128, 128))
	p2_rect = Rect2(Vector2(player2.global_position.x - 64, player2.global_position.y - 64), Vector2(128, 128))
	if p1_rect.intersects(p2_rect):
		var clip = p1_rect.intersection(p2_rect).size.x
		if player1.global_position.x < player2.global_position.x:
			clip = -clip
		if p1_clip.length() > p2_clip.length():
			player2.global_position.x -= clip
		else:
			player1.global_position.x += clip
			
	var center = (player1.position + player2.position)/2
	if center.x - 576 < get_parent().left:
		get_parent().left = max(center.x - 576, get_parent().max_left)
		get_parent().right = min(center.x + 576, get_parent().max_right)
	elif center.x + 576 > get_parent().right:
		get_parent().right = min(center.x + 576, get_parent().max_right)
		get_parent().left = max(center.x - 576, get_parent().max_left)
		
	if center.x - 464 < get_parent().wall_left:
		get_parent().wall_left = max(center.x - 464, get_parent().max_left)
		get_parent().wall_right = min(center.x + 464, get_parent().max_right)
	elif center.x + 464 > get_parent().wall_right:
		get_parent().wall_right = min(center.x + 464, get_parent().max_right)
		get_parent().wall_left = max(center.x - 464, get_parent().max_left)
		
func _draw():
	var rect = Rect2(Vector2(- 1152,  - 648), Vector2(1152, 648))
	draw_rect(rect, Color(1, 0, 0, 0.5))
	var rect2 = Rect2(Vector2(get_parent().left, 0), Vector2(100, 648))
	draw_rect(rect2, Color(0, 1, 0, 0.5))
	var rect3 = Rect2(Vector2(get_parent().right - 100, 0), Vector2(100, 648))
	draw_rect(rect3, Color(0, 1, 0, 0.5))
	rect2 = Rect2(Vector2(get_parent().wall_left - 50, 0), Vector2(50, 648))
	draw_rect(rect2, Color(0, 1, 1, 0.5))
	rect3 = Rect2(Vector2(get_parent().wall_right, 0), Vector2(50, 648))
	draw_rect(rect3, Color(0, 1, 1, 0.5))

func _process(delta):
	queue_redraw()
		
