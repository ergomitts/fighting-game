extends Node

@export var max_value := 100

var value := 0

func use(amount: int):
	if amount <= value:
		value = max(value - amount, 0)

func gain(amount: int):
	value = min(amount + value, max_value)
