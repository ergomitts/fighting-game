extends Node

@export var max_value := 100

var value := 0

func use(amount: int):
	if amount <= value:
		value -= amount

func gain(amount: int):
	value = min(amount + value, max_value)
