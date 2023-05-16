extends Node2D

@export var player1 : Node2D
@export var player2 : Node2D

var left = 0
var right = 1152
var wall_left = 0
var wall_right = 921.6
var max_left = -1152
var max_right = 2304

func stage_clip(pos : Vector2):
	var clip_x = 0
	var clip_y = 0
	if pos.x - 64 < 0:
		clip_x = 0 - (pos.x - 64)
	elif pos.x + 64 > 1152:
		clip_x = 1152 - (pos.x + 64)
	if pos.y + 64 > 500:
		clip_y = 500 - (pos.y + 64)
	return Vector2(clip_x, clip_y)
