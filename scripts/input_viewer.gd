extends Control

const FRAME_RECT := preload("res://scenes/ui/frame.tscn")

@onready var player1 := $Player1
@onready var player2 := $Player2

<<<<<<< HEAD
=======
var counter1 := 1
var counter2 := 1

>>>>>>> dev
func _ready():
	for i in range(0, 20):
		for x in range(0, 2):
			var frame = FRAME_RECT.instantiate()
			if x == 0:
				player1.add_child(frame)
			else:
				player2.add_child(frame)
				
func change_dir(arrow: TextureRect, axis: Vector2):
	match axis:
		Vector2(-1, 1):
			arrow.texture.region.position.x = 0
		Vector2(0, 1):
			arrow.texture.region.position.x = 64
		Vector2(1, 1):
			arrow.texture.region.position.x = 128
		Vector2(-1, 0):
			arrow.texture.region.position.x = 192
		Vector2(0, 0):
			arrow.texture.region.position.x = 256
		Vector2(1, 0):
			arrow.texture.region.position.x = 320
		Vector2(-1, -1):
			arrow.texture.region.position.x = 384
		Vector2(0, -1):
			arrow.texture.region.position.x = 448
		Vector2(1, -1):
			arrow.texture.region.position.x = 512 			
				
func update(id : int, buffer : Array):
	var list = player1 if id == 1 else player2
<<<<<<< HEAD
	var last_input = buffer[buffer.size()-2]
=======
>>>>>>> dev
	var current_input = buffer[buffer.size()-1]
	
	var last_label = list.get_child(list.get_child_count() - 1)
	var pressed = last_label.get_node("Pressed")
	
	for i in range(0, list.get_child_count()):
		var last_pressed = list.get_child(max(i - 1, 0)).get_node("Pressed")
		var current_pressed = list.get_child(i).get_node("Pressed")
		last_pressed.get_node("Arrow").texture.region.position.x = current_pressed.get_node("Arrow").texture.region.position.x
<<<<<<< HEAD
		for x in range(last_pressed.get_children().size()):
			last_pressed.get_child(x).visible = current_pressed.get_child(x).visible
	
	change_dir(pressed.get_node("Arrow"), current_input.axis)
	for button in current_input.buttons:
		pressed.get_node(button.capitalize()).visible = current_input.buttons[button] >= 0
=======
		last_pressed.get_node("Frames").text = current_pressed.get_node("Frames").text
		for x in range(last_pressed.get_children().size()):
			last_pressed.get_child(x).visible = current_pressed.get_child(x).visible
	
	if id == 1:
		counter1 = 0
	else:
		counter2 = 0
	
	change_dir(pressed.get_node("Arrow"), current_input.axis)
	for button in current_input.buttons:
		pressed.get_node(button.capitalize()).visible = current_input.buttons[button] >= 0
		
func _process(delta):
	if Input.is_action_just_pressed("toggle_input_display"):
		visible = not visible
		
func _physics_process(delta):
	for i in range(2):
		var list = player1 if i == 1 else player2
		var last_label = list.get_child(list.get_child_count() - 1)
		var pressed = last_label.get_node("Pressed")
		if i == 1:
			counter1 = min(counter1 + 1, 999)
			pressed.get_node("Frames").text = str(counter1).rpad(3)
		else:
			counter2 = min(counter2 + 1, 999)
			pressed.get_node("Frames").text = str(counter2).lpad(3)
>>>>>>> dev
	
			
		
