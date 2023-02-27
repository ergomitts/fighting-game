extends Node2D

# Editor Variables

var DEBUGGING := true

# Game Variables

const CharacterDirectories := ['res://characters/TestFighter/TestFighter.tscn']
const CharacterScenes := []

# In-Game Variables

const RoundDuration := 90
const RoundWins := 2

const SpawnDistance := 400
const WallDistanceMax := 2400
const WallDistanceCutOff := 1920

var StageDistance := 4800
var StageLeft := -1200
var StageRight := 1200
var StageTop := -2400
var StageBottom := 0

var players = []

func draw_box(shape: Rect2, color: Color):
	draw_rect(shape, color, false)
	draw_rect(shape, Color(color.r, color.g, color.b, 0.2), true)

func load_characters():
	for directory in CharacterDirectories:
		CharacterScenes.append(load(directory))

func draw_limits():
	var height = abs(StageBottom - StageTop)
	var width = abs(StageRight - StageLeft)
	draw_box(Rect2(StageLeft - 2, StageTop, 4, height), Color.violet)
	draw_box(Rect2(StageRight - 2, StageTop, 4, height), Color.violet)
	draw_box(Rect2(-width/2, StageBottom - 2, width, 4), Color.purple)
	draw_box(Rect2(-width/2, StageTop - 2, width, 4), Color.purple)

func _process(delta: float):
	update()

func _draw():
	if GameGlobals.get('DEBUGGING'):
		draw_limits()
