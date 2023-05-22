extends Node

@onready var viewer := $InputViewer

var controllers = []

func _ready():
	for i in range(0, 2):
		var controller = Controller.new()
		controller.id = i + 1
		add_child(controller)
		controllers.append(controller)
		controller.connect("changed", update_viewer)

func update_viewer(id):
	var controller = controllers[id - 1]
	viewer.update(id, controller.buffer)

func _physics_process(_delta):
	for controller in controllers:
		controller.update()
