extends Node

enum Stance {
	Normal,
	Crouching,
}

enum AttackType {
	Medium,
	Low,
	High,
	AirUnblockable,
	Unblockable
}

const CharacterPaths = ["res://characters/character_object.tscn"]

enum MotionInput {
	HalfCircleF_GG,
	HalfCircleF,
	HalfCircleB,
	DragonPunch,
	QuarterCircleF,
	QuarterCircleB,
	DTapF,
	DTapB,
	DTapD,
	Empty
}

enum Buttons {
	Light,
	Medium,
	Heavy,
	Special
}

const MOTION_INPUT_DATA = {
	# Tricky Inputs
	MotionInput.HalfCircleF_GG : {
		'directions' : [Vector2.RIGHT, Vector2.RIGHT + Vector2.DOWN, Vector2.DOWN, Vector2.DOWN + Vector2.LEFT, Vector2.LEFT, Vector2.RIGHT], 
		'duration' : 32, 
		'misinputs' : 4
	},
	MotionInput.HalfCircleF : {
		'directions' : [Vector2.LEFT, Vector2.LEFT + Vector2.DOWN, Vector2.DOWN, Vector2.DOWN + Vector2.RIGHT, Vector2.RIGHT], 
		'duration' : 32, 
		'misinputs' : 4,
	},
	MotionInput.HalfCircleB : {
		'directions' : [Vector2.RIGHT, Vector2.RIGHT + Vector2.DOWN, Vector2.DOWN, Vector2.DOWN + Vector2.LEFT, Vector2.LEFT], 
		'duration' : 32, 
		'misinputs' : 4,
	},
	
	# Simple Inputs
	MotionInput.DragonPunch : {
		'directions' : [Vector2.RIGHT, Vector2.DOWN, Vector2.DOWN + Vector2.RIGHT], 
		'duration' : 24, 
		'misinputs' : 3
	},
	MotionInput.QuarterCircleF : {
		'directions' : [Vector2.DOWN, Vector2.DOWN + Vector2.RIGHT, Vector2.RIGHT], 
		'duration' : 15, 
		'misinputs' : 2
	},
	MotionInput.QuarterCircleB : {
		'directions' : [Vector2.DOWN, Vector2.DOWN + Vector2.LEFT, Vector2.LEFT], 
		'duration' : 15, 
		'misinputs' : 2
	},
	
	# Double Taps
	MotionInput.DTapF : {
		'directions' : [Vector2.ZERO, Vector2.RIGHT, Vector2.ZERO, Vector2.RIGHT],
		'duration' : 14,
		'misinputs' : 1
	},
	MotionInput.DTapB : {
		'directions' : [Vector2.ZERO, Vector2.LEFT, Vector2.ZERO, Vector2.LEFT],
		'duration' : 14,
		'misinputs' : 1
	},
	MotionInput.DTapD : {
		'directions' : [Vector2.ZERO, Vector2.DOWN, Vector2.ZERO, Vector2.DOWN],
		'duration' : 14,
		'misinputs' : 1
	},
	MotionInput.Empty : {}
}

