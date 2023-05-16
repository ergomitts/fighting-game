extends Camera2D

var t = 0

func _process(delta):
	t += delta
	position = Vector2(sin(t * 2) * 505, 0)
