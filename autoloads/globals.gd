extends Node

var debug = true

const SPAWN_DISTANCE = 480.0
const MAX_PLAYER_DISTANCE = 1980.0

var StageTop = 0.0
var StageBottom = 480.0
var StageLeft = -1920.0
var StageRight = 1920.0

var limit_left = -960.0
var limit_right = 960.0

var players = []

func _process(delta):
	if Input.is_action_just_pressed("toggle_hitboxes"):
		debug = not debug
