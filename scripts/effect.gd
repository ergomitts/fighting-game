extends Node2D

@onready var main := $Main
@onready var timer := $Timer
@onready var animation_player := $AnimationPlayer

@export var animation := "default"
@export var despawn_time := 1.0

func _ready():
	if animation != "burst":
		main.animation = animation
		main.play()
		$Burst.hide()
	else:
		main.hide()
		animation_player.play("boom")
	timer.one_shot = true
	timer.start(despawn_time)
	
	main.connect("animation_looped", ended)
	timer.connect("timeout", despawn)
	
func ended():
	hide()
	
func despawn():
	queue_free()
