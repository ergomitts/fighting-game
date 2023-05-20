extends Control

@onready var player1 := $Player1
@onready var player2 := $Player2

func _ready():
	for i in range(0, 20):
		for x in range(0, 2):
			var label := Label.new()
			label.size = Vector2(128, 54)
			label.text = ""
			if x == 0:
				player1.add_child(label)
			else:
				player2.add_child(label)
				
func update(id : int, buffer : Array):
	var list = player1 if id == 1 else player2
	var last_input = buffer[buffer.size()-1]
	var last_label = list.get_child(list.get_child_count() - 1)
	var txt = str(last_input.axis)
	
	for button in last_input.buttons:
		if last_input.buttons[button] >= 0:
			txt += " " + button
	
	if last_label.text != txt:
		for i in range(0, list.get_child_count()):
			var last = list.get_child(max(i - 1, 0))
			last.text = list.get_child(i).text
		last_label.text = txt
	
			
		
