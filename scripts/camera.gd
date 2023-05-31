extends Camera2D

@onready var shaker := Shaker.new()

@export var cutoff := 960
@export var center_offset := Vector2(0, -90)
@export var zoom_scale := 1.2
@export var wall_thickness := 300.0
@export var subject := -1

func _ready():
	add_child(shaker)

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
	
func _process(delta):
	if Globals.players.size() < 1:
		return
	
	if subject != -1:
		var player = Globals.players[subject]
		position = lerp(position, player.global_position + center_offset, 10 * delta)
		zoom = lerp(zoom, Vector2(1.5, 1.5), 5 * delta)
	else:
		var center = get_center()
		position = center + center_offset
		
		var left = center.x - Globals.MAX_PLAYER_DISTANCE/2.0
		var right = center.x + Globals.MAX_PLAYER_DISTANCE/2.0
		var left_wall = Globals.StageLeft - wall_thickness
		var right_wall = Globals.StageRight + wall_thickness
		if left < left_wall:
			position.x += left_wall - left
		elif right > right_wall:
			position.x += right_wall - right

		var distance = get_distance()
		var _zoom = zoom_scale
		if distance > cutoff:
			_zoom = zoom_scale + (1-zoom_scale) * ((distance - cutoff)/(Globals.MAX_PLAYER_DISTANCE - cutoff)) 
		zoom = lerp(zoom, Vector2(_zoom, _zoom), 50 * delta)
		
		offset = shaker.position
	
