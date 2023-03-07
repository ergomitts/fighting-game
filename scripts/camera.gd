extends Camera2D

const SMOOTHING := 50.0
const CUT_OFF_RATIO := 0.8
const FLOOR_PADDING := 150

var rng := RandomNumberGenerator.new()
var target : Node2D = null
var distance := 0

func _init():
	current = true
	
	smoothing_enabled = true
	smoothing_speed = 15
	
	limit_top = GameGlobals.StageTop
	limit_bottom = GameGlobals.StageBottom + FLOOR_PADDING
	limit_left = GameGlobals.StageLeft
	limit_right = GameGlobals.StageRight

func get_center() -> Vector2:
	if GameGlobals.players.size() == 0:
		return Vector2(abs(GameGlobals.StageLeft - GameGlobals.StageRight)/2, (abs(GameGlobals.StageTop - GameGlobals.StageBottom)/2)) 
	return (GameGlobals.players[0].position + GameGlobals.players[1].position)/2

func _process(delta: float) -> void:
	limit_left = GameGlobals.StageLeft
	limit_right = GameGlobals.StageRight
	
	if is_instance_valid(target):
		position = lerp(position, target.position, SMOOTHING * delta)
	else:
		position = lerp(position, get_center(), SMOOTHING * delta)
		
	if distance > GameGlobals.WallDistanceMax * CUT_OFF_RATIO:
		var _zoom = distance/(GameGlobals.WallDistanceMax * CUT_OFF_RATIO)
		zoom = lerp(zoom, Vector2(_zoom, _zoom), SMOOTHING * delta)
	else:
		zoom = lerp(zoom, Vector2(1, 1), SMOOTHING * delta)
