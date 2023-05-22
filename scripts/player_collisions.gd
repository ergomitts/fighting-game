extends Node

var in_corner = 0

func wall_clip(rect : Rect2):
	var x := 0
	var position := rect.position.x
	var size := rect.size.x
	if position < Globals.limit_left:
		x = Globals.limit_left - position
	elif position + size > Globals.limit_right:
		x = Globals.limit_right - (position + size)
	return x
	
func floor_clip(character : CharacterObject):
	var y := 0
	var rect := character.push_box.get_global() as Rect2
	var position := rect.position.y
	var size := rect.size.y
	if position + size > Globals.StageBottom:
		var height = character.push_box.shape.position.y + size
		character.position.y = Globals.StageBottom - height
	
func player_clip(rect1 : Rect2, rect2 : Rect2):
	var rect = rect1
	var _rect = rect2
	if rect.intersects(_rect):
		var clip = rect.intersection(_rect).size.x
		if rect.position.x < _rect.position.x:
			clip = -clip
		return clip
	return 0

func push_collisions():
	var player1 = Globals.players[0]
	var player2 = Globals.players[1]
	
	var p1_corner = player1.get_corner()
	var p2_corner = player2.get_corner()
	
	if player1.push_box.can_push and player2.push_box.can_push:
		var clip = player_clip(player1.push_box.get_global(), player2.push_box.get_global())
		player1.position.x += clip/2
		player2.position.x -= clip/2
	
	var clip_1 = wall_clip(player1.push_box.get_global())
	var clip_2 = wall_clip(player2.push_box.get_global())
	floor_clip(player1)
	floor_clip(player2)
	player1.position.x += clip_1
	player2.position.x += clip_2
	
	if player1.push_box.can_push and player2.push_box.can_push:
		var clip = player_clip(player1.push_box.get_global(), player2.push_box.get_global())
		if abs(clip) > 0:
#			if abs(clip_1) > abs(clip_2):
#				player2.position.x -= clip
#			else:
#				player1.position.x += clip
	
			if in_corner == 1:
				var rect = player1.push_box.get_global()
				if p1_corner < 0:
					player2.position.x = (rect.position.x + rect.size.x) - (player2.push_box.shape.position.x)
				elif p1_corner > 0:
					player2.position.x = rect.position.x  - (player2.push_box.shape.position.x + player2.push_box.shape.size.x)
			elif in_corner == 2:
				var rect = player2.push_box.get_global()
				if p2_corner < 0:
					player1.position.x =  (rect.position.x + rect.size.x) - (player1.push_box.shape.position.x )
				elif p2_corner > 0:
					player1.position.x = rect.position.x  - (player1.push_box.shape.position.x + player1.push_box.shape.size.x)
		
	if in_corner == 0:
		if player1.in_corner():
			in_corner = 1
		elif player2.in_corner():
			in_corner = 2
	elif !player1.in_corner() and !player2.in_corner():
		in_corner = 0		
		
func update_walls():		
	var player1 = Globals.players[0]
	var player2 = Globals.players[1]			
	var center = (player1.position + player2.position)/2
	var left = center.x - Globals.MAX_PLAYER_DISTANCE/2
	var right = center.x + Globals.MAX_PLAYER_DISTANCE/2
	if left < Globals.limit_left or right > Globals.limit_right:
		Globals.limit_left = max(left, Globals.StageLeft)
		Globals.limit_right = min(right, Globals.StageRight)
		
func hit_collisions():
	var player1 = Globals.players[0]
	var player2 = Globals.players[1]
	for i in range(0, 2):
		var hitter = player1 if i == 0 else player2
		var hitbox = player1.hit_box if i == 0 else player2.hit_box
		var hurtbox = player2.hurt_box if i == 0 else player1.hurt_box
		var pos = hitbox.check_collision(hurtbox)
		if pos != null:
			hitter.hit_confirmed = true
		
func _physics_process(delta):
	push_collisions()
	update_walls()
	hit_collisions()
	
