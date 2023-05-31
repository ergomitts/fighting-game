extends Node

@export var max_health := 420
@export_range(1, 20) var toughness := 1

<<<<<<< HEAD
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
=======
var value := max_health

func take_damage(amount: int, ignore := false):
	var damage = amount
	if value < max_health * 0.25:
		damage = floor(amount * max(0.7 - toughness/20.0, 0.15))
	elif value < max_health * 0.45:
		damage = floor(amount * max(0.8 - toughness/20.0, 0.2))
	elif value < max_health * 0.65:
		damage = floor(amount * max(1.0 - toughness/20.0, 0.3))
	else:
		damage = amount
	value -= max(damage, 1) if amount > 0 else 0
	
func heal(amount: int):
	value = min(value + amount, max_health)
>>>>>>> dev
