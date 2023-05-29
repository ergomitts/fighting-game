extends Node

@export var max_health := 420
@export_range(1, 20) var toughness := 1

var value := max_health

func take_damage(amount : int):
	var damage = amount
	if value < max_health * 0.25:
		damage = floor(amount * max(0.5 - toughness/20.0, 0.15))
	elif value < max_health * 0.45:
		damage = floor(amount * max(0.7 - toughness/20.0, 0.2))
	elif value < max_health * 0.65:
		damage = floor(amount * max(0.9 - toughness/20.0, 0.3))
	else:
		damage = amount
	value -= max(damage, 1)
	
func heal(amount : int):
	value += amount
