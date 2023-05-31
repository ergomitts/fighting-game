extends Node

const PROJECTILE_SCENE := preload("res://scenes/projectile.tscn")

func can_spawn_projectile():
	return get_child_count() < 2

func spawn_projectile(pos, attack: ActionState, flipped := false):
	var projectile = PROJECTILE_SCENE.instantiate()
	projectile.attack = attack
	projectile.speed = attack.projectile_speed
	projectile.hits = attack.projectile_hit_amount
	projectile.global_position = pos
	add_child(projectile)
	projectile.flipped = flipped
	
func clear():
	for i in get_children():
		i.queue_free()
