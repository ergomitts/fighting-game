extends Node

const CHARACTER_SCENE = preload('res://characters/Character.tscn')
const CAMERA_SCENE = preload('res://scripts/camera.gd')

var camera : Camera2D

func _ready():
	camera = CAMERA_SCENE.new()
	add_child(camera)
	start_game()
	
func get_center():
	return (GameGlobals.players[0].position + GameGlobals.players[1].position)/2	
	
func get_distance():
	var left = GameGlobals.players[0].position.x - GameGlobals.players[0].push_box.shape.size.x/2
	var right = GameGlobals.players[1].position.x + GameGlobals.players[1].push_box.shape.size.x/2
	
	return Vector2(left, 0).distance_to(Vector2(right, 0))
	
func start_game():
	camera.position.x = 0
	for i in range(0, 2):
		var player = CHARACTER_SCENE.instance()
		add_child(player)
		GameGlobals.players.append(player)
		
		var height = player.push_box.shape.size.y/2
		var offset = GameGlobals.SpawnDistance * (-1 if i == 0 else 1)
		player.position = Vector2(offset, GameGlobals.StageBottom - height)
		player.id = i
		if i == 1:
			GameGlobals.players[0].enemy = player
			player.enemy = GameGlobals.players[0]

func _physics_process(delta: float) -> void:
	if GameGlobals.players.size() > 0:
		var center = get_center()
		var distance = get_distance()
		
		if center.x - GameGlobals.WallDistanceMax/2 < - GameGlobals.StageDistance/2:
			GameGlobals.StageLeft = - GameGlobals.StageDistance/2
			GameGlobals.StageRight = - GameGlobals.StageDistance/2 + GameGlobals.WallDistanceMax
		elif center.x + GameGlobals.WallDistanceMax/2 > GameGlobals.StageDistance/2:
			GameGlobals.StageLeft = GameGlobals.StageDistance/2 - GameGlobals.WallDistanceMax
			GameGlobals.StageRight = GameGlobals.StageDistance/2
		else:
			GameGlobals.StageLeft = center.x - GameGlobals.WallDistanceMax/2
			GameGlobals.StageRight = center.x + GameGlobals.WallDistanceMax/2
			
		camera.distance = distance
