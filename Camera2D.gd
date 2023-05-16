extends Camera2D

@export var player1 : Node2D
@export var player2 : Node2D

func _physics_process(delta):
	var center = (player1.position + player2.position)/2
	global_position = center + Vector2(0, -90)
	
	var left = global_position.x - 576
	var right = global_position.x + 576
	if left < get_parent().left:
		global_position.x += get_parent().left - left
	elif right > get_parent().right:
		global_position.x += get_parent().right - right
	
	var distance = abs(player1.global_position.x - player2.global_position.x)
	var zoom_scale = 1.2
	if distance > 576:
		zoom_scale = 1.2 - 0.2 * ((distance-576)/448)
	zoom = lerp(zoom, Vector2(zoom_scale, zoom_scale), 0.3)
#	limit_left = get_parent().left
#	limit_right = get_parent().right

