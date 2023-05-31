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
		get_tree().change_scene_to_file("res://scenes/test_room.tscn")
