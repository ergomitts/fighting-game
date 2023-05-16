extends Node

@export var max_health := 420
@export_range(1, 20) var toughness := 1

var health := max_health

func take_damage(amount : int):
	if health < max_health * 0.25:
		health -= floor(amount * max(0.9 - toughness/20, 0.15))
	elif health < max_health * 0.45:
		health -= floor(amount * max(1.0 - toughness/20, 0.2))
	elif health < max_health * 0.65:
		health -= floor(amount * (1.05 - toughness/20))
	else:
		health -= amount
		
func heal(amount : int):
	health += amount
