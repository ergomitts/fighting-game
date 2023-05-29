extends Node

@export var max_defense := 180
@export var heal_delay := 90
@export var heal_cooldown := 5
@export var heal_rate := 60
@export var heal_amount := 10
var value := max_defense
var changed := false
var depleted := false

var frame := 0

func take_damage(amount: int):
	value = max(value - amount, 0)
	changed = true
	if value <= 0:
		frame = heal_delay
		depleted = true

func heal(amount: int):
	value = min(value + amount, max_defense)

func update(delta: float):
	if value <= 0:
		if frame == 0:
			heal(heal_amount)
	elif value < max_defense:
		if changed:
			changed = false
			frame = heal_cooldown
		if frame == 0:
			if depleted:
				frame = 1
				heal(1)
			else:
				frame = heal_rate
				heal(heal_amount)
	if value >= max_defense:
		depleted = false
	if frame > 0:
		frame -= 1
