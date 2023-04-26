extends Node

func stage_clip(rect : Rect2):
	var x := 0
	var y := 0
	var position := rect.position
	var size := rect.size
	if position.x - size.x/2 < Globals.limit_left:
		x = Globals.limit_left - (position.x - size.x/2)
	elif position.x + size.x/2 > Globals.limit_right:
		x = Globals.limit_right - (position.x + size.x/2)
	if position.y + size.y/2 > Globals.StageBottom:
		y = Globals.StageBottom - (position.y + size.y/2)
	return Vector2(x, y)
	
func player_clip(rect1 : Rect2, rect2 : Rect2):
	var rect = rect1
	var _rect = rect2
	if rect.intersects(_rect):
		var clip = rect.intersection(_rect).size.x
		if rect.position.x < _rect.position.x:
			clip = -clip
		return clip
	return 0
	
func _physics_process(delta):
	var player1 = Globals.players[0]
	var player2 = Globals.players[1]
	var clip = player_clip(player1.push_box.get_global(), player2.push_box.get_global())
	player1.position.x += clip/2
	player2.position.x -= clip/2
	var s_clip_1 = stage_clip(player1.push_box.get_global())
	var s_clip_2 = stage_clip(player2.push_box.get_global())
	player1.position += s_clip_1
	player2.position += s_clip_2
	clip = player_clip(player1.push_box.get_global(), player2.push_box.get_global())
	if abs(clip) > 0:
		if s_clip_1.length() > s_clip_2.length():
			player2.position.x -= clip
		else:
			player1.position.x += clip
	
	
