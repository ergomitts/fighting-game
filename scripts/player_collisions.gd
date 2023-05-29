extends Node

var in_corner = 0

signal player_hit

func wall_clip(rect : Rect2):
	var x := 0.0
	var position := rect.position.x
	var size := rect.size.x
	if size <= 0:
		return 0
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
	if position + size > Globals.StageBottom and size > 0:
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
		player1.position.x += clip/2.0
		player2.position.x -= clip/2.0
	
	var clip_1 = wall_clip(player1.push_box.get_global())
	var clip_2 = wall_clip(player2.push_box.get_global())
	floor_clip(player1)
	floor_clip(player2)
	player1.position.x += clip_1
	player2.position.x += clip_2
	
	if player1.push_box.can_push and player2.push_box.can_push:
		var clip = player_clip(player1.push_box.get_global(), player2.push_box.get_global())
		if abs(clip) > 0:
			if in_corner == 1:
				var rect = player1.push_box.get_global()
				if p1_corner < 0:
					player1.position.x = Globals.limit_left - player1.push_box.shape.position.x
					player2.position.x = (rect.position.x + rect.size.x) - (player2.push_box.shape.position.x)
				elif p1_corner > 0:
					player1.position.x = Globals.limit_right - (player1.push_box.shape.position.x + player1.push_box.shape.size.x)
					player2.position.x = rect.position.x  - (player2.push_box.shape.position.x + player2.push_box.shape.size.x)
			elif in_corner == 2:
				var rect = player2.push_box.get_global()
				if p2_corner < 0:
					player1.position.x =  (rect.position.x + rect.size.x) - (player1.push_box.shape.position.x)
					player2.position.x = Globals.limit_left - player2.push_box.shape.position.x
				elif p2_corner > 0:
					player1.position.x = rect.position.x  - (player1.push_box.shape.position.x + player1.push_box.shape.size.x)
					player2.position.x = Globals.limit_right - (player2.push_box.shape.position.x + player2.push_box.shape.size.x)
		
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
	var center = (player1.position + player2.position)/2.0
	var left = center.x - Globals.MAX_PLAYER_DISTANCE/2.0
	var right = center.x + Globals.MAX_PLAYER_DISTANCE/2.0
	if left < Globals.limit_left or right > Globals.limit_right:
		Globals.limit_left = max(left, Globals.StageLeft)
		Globals.limit_right = min(right, Globals.StageRight)
		
func hit_collisions():
	var player1 = Globals.players[0]
	var player2 = Globals.players[1]
	
	var p1_clash := false
	var p2_clash := false
	var p1_hit
	var p2_hit
	var p1_attack = player1.state_machine.state
	var p2_attack = player2.state_machine.state
	
	for i in range(0, 2):
		var hit = player1.hit_box.check_collision(player2.hurt_box) if i == 0 else player2.hit_box.check_collision(player1.hurt_box)
		if hit != null:
			if i == 0:
				p1_hit = hit
			elif i == 1:
				p2_hit = hit
		else:
			var clash = player1.hit_box.check_collision(player2.hit_box)
			if clash != null:
				if i == 0:
					p1_clash = true
				elif i == 1:
					p2_clash = true
	
	if p1_hit or p2_hit or (p1_clash and p2_clash):
		player_hit.emit(p1_hit, p2_hit, p1_clash and p2_clash, p1_attack, p2_attack)
		
func _physics_process(delta):
	push_collisions()
	update_walls()
	hit_collisions()
	
