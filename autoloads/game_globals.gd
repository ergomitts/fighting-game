extends Node

# Editor Variables

var DEBUGGING := true

# Game Variables

const CharacterDirectories := ['res://characters/TestFighter/TestFighter.tscn']
const CharacterScenes := []

# In-Game Variables

const RoundDuration := 90
const RoundWins := 2

const PlayerDistanceMax := 1980
const PlayerDistanceCutOff := 1920

const MinX := 0
const MaxX := 0
const MinY := 0
const MaxY := 0

func load_characters():
	for directory in CharacterDirectories:
		CharacterScenes.append(load(directory))
