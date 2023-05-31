extends CanvasLayer

@onready var main := $Main
@onready var animation_player := $Main/AnimationPlayer
@onready var player1 := $Player1
@onready var player2 := $Player2

func round_start(round):
	main.get_node("Ready").text = "Round " + str(round)
	animation_player.play("round_start")

func round_end(victor):
	if victor != -1:
		main.get_node("Winner").text = "Player " + str(victor + 1) + " Wins!"
	else:
		main.get_node("Winner").text = "Tie!"
	animation_player.play("round_end")
	
func update_counter(i, combo := 0, callout := -1):
	var control := player1 if i == 0 else player2
	
	control.get_node("Combo").text = "Combo: " + str(combo).rpad(3)
	control.get_node("Combo/AnimationPlayer").stop()
	control.get_node("Combo/AnimationPlayer").play("combo")
	if callout == 0:
		control.get_node("Callout").text = "Counter!"
		control.get_node("Callout/AnimationPlayer").stop()
		control.get_node("Callout/AnimationPlayer").play("default")
	elif callout == 1:
		control.get_node("Callout").text = "Punish!"
		control.get_node("Callout/AnimationPlayer").stop()
		control.get_node("Callout/AnimationPlayer").play("default")
