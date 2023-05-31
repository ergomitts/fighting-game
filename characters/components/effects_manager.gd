extends Node

const EFFECT_SCENE := preload("res://scenes/effect.tscn")

func spawn_effect(pos, animation, time, flipped := false):
	var effect = EFFECT_SCENE.instantiate()
	effect.animation = animation
	effect.despawn_time = time
	effect.global_position = pos
	add_child(effect)
	effect.main.flip_h = flipped
	
func clear():
	for i in get_children():
		i.queue_free()
