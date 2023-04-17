extends Node

@onready var viewer := $InputViewer

var controllers = []

func _ready():
	for i in range(0, 2):
		var controller = Controller.new()
		controller.id = i + 1
		add_child(controller)
		controllers.append(controller)

func _physics_process(_delta):
	for controller in controllers:
		controller.update()
		viewer.update(controller.id, controller.buffer)
