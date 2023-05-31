extends Control

var eready := false

func _ready():
	if Globals.winner != -1:
		$WinnerLabel.text = "[wave amp=50.0]Player " + str(Globals.winner + 1) + " Wins![/wave]"
	await get_tree().create_timer(1.0).timeout
	eready = true

func _input(event):
	if event.is_echo():
		return
	if event is InputEventKey and event.is_pressed() and eready:
		if event.is_action_pressed("p1_left"):
			get_tree().change_scene_to_file("res://scenes/game_room.tscn")
		elif event.is_action_pressed("p1_right"):
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

