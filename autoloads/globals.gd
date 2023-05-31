extends Node

<<<<<<< HEAD
var debug = true

const SPAWN_DISTANCE = 480
const MAX_PLAYER_DISTANCE = 1980

var StageTop = 0
var StageBottom = 480
var StageLeft = -1920
var StageRight = 1920

var limit_left = -960
var limit_right = 960

var players = []
=======
var debug = false

const SPAWN_DISTANCE = 480.0
const MAX_PLAYER_DISTANCE = 1980.0

var StageTop = 0.0
var StageBottom = 480.0
var StageLeft = -1920.0
var StageRight = 1920.0

var limit_left = -960.0
var limit_right = 960.0

var winner = -1

var players = []

func _process(delta):
	if Input.is_action_just_pressed("toggle_hitboxes"):
		debug = not debug
>>>>>>> dev
