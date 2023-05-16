extends Camera2D

@export var cutoff := 960
@export var center_offset := Vector2(0, -90)
@export var zoom_scale := 1.2

func get_center():
	return (Globals.players[0].global_position + Globals.players[1].global_position)/2
	
func get_distance():
	var player1 := Globals.players[0] as CharacterObject
	var player2 := Globals.players[1] as CharacterObject
	
	var left = player1.push_box.get_center().x - player1.push_box.shape.size.x/2
	var right = player2.push_box.get_center().x + player2.push_box.shape.size.x/2
	
	if player1.global_position.x > player2.global_position.x:
		left = player2.push_box.get_center().x - player2.push_box.shape.size.x/2
		right = player1.push_box.get_center().x + player1.push_box.shape.size.x/2
	
	return abs(left - right)	
	
func _physics_process(delta):
	var center = get_center()
	position = center + center_offset
	
#	limit_left = Globals.limit_left
#	limit_right = Globals.limit_right
	
#	var left = center.x - Globals.MAX_PLAYER_DISTANCE/2
#	var right = center.x + Globals.MAX_PLAYER_DISTANCE/2
#	if left < Globals.StageLeft:
#		position.x += Globals.StageLeft - left
#	elif right > Globals.StageRight:
#		position.x += Globals.StageRight - right
	
	var player1 = Globals.players[0]
	var player2 = Globals.players[1]
	var distance = get_distance()
	var _zoom = zoom_scale
	if distance > cutoff:
		_zoom = zoom_scale + (1-zoom_scale) * ((distance - cutoff)/(Globals.MAX_PLAYER_DISTANCE - cutoff)) 
	zoom = lerp(zoom, Vector2(_zoom, _zoom), 50 * delta)
	
	
