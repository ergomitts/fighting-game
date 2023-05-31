extends Control

var eready := false
var pressed := false

func _ready():
	await get_tree().create_timer(1.0).timeout
	eready = true

func _input(event):
	if event.is_echo():
		return
	if event is InputEventKey and event.is_pressed() and eready:
		if pressed:
			return
		if event.is_action_pressed("p1_left"):
			pressed = true
			get_tree().change_scene_to_file("res://scenes/game_room.tscn")
		elif event.is_action_pressed("p1_right"):
			pressed = true
			get_tree().change_scene_to_file("res://scenes/test_room.tscn")
