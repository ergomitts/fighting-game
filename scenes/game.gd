extends Node

const CHARACTER_SCENE = preload('res://characters/Character.tscn')
const CAMERA_SCENE = preload('res://scripts/camera.gd')

var camera : Camera2D

func _ready():
	camera = CAMERA_SCENE.new()
	add_child(camera)
	start_game()
	
func get_center():
	
	var left = 0
	var right = 0
	
	if GameGlobals.players[0].global_position.x < GameGlobals.players[1].global_position.x:
		left = GameGlobals.players[0].global_position.x - GameGlobals.players[0].push_box.shape.size.x/2
		right = GameGlobals.players[1].global_position.x + GameGlobals.players[1].push_box.shape.size.x/2
	else:
		left = GameGlobals.players[1].global_position.x - GameGlobals.players[1].push_box.shape.size.x/2
		right = GameGlobals.players[0].global_position.x + GameGlobals.players[0].push_box.shape.size.x/2
	
	return Vector2(left + right, 0)/2
	
func get_distance():
	var left = 0
	var right = 0
	
	if GameGlobals.players[0].global_position.x < GameGlobals.players[1].global_position.x:
		left = GameGlobals.players[0].global_position.x - GameGlobals.players[0].push_box.shape.size.x/2
		right = GameGlobals.players[1].global_position.x + GameGlobals.players[1].push_box.shape.size.x/2
	else:
		left = GameGlobals.players[1].global_position.x - GameGlobals.players[1].push_box.shape.size.x/2
		right = GameGlobals.players[0].global_position.x + GameGlobals.players[0].push_box.shape.size.x/2
		
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
		GameGlobals.players[0].global_position += GameGlobals.players[0].velocity
		GameGlobals.players[1].global_position += GameGlobals.players[1].velocity
		
		var p1_rect := GameGlobals.players[0].push_box.get_global_rect() as Rect2
		var p2_rect := GameGlobals.players[1].push_box.get_global_rect() as Rect2
		
		if p1_rect.intersects(p2_rect):
			var clip = p1_rect.clip(p2_rect).size.x/2
			
			var p1_facing = 1 if GameGlobals.players[0].global_position.x < GameGlobals.players[1].global_position.x else -1
			var p2_facing = -1 if GameGlobals.players[0].global_position.x < GameGlobals.players[1].global_position.x else 1
			
			GameGlobals.players[0].global_position.x -= clip * p1_facing
			GameGlobals.players[1].global_position.x -= clip * p2_facing
			
			var p1_wall_clip = GameGlobals.players[0].snap_to_corner(Vector2.ZERO).x
			var p2_wall_clip = GameGlobals.players[1].snap_to_corner(Vector2.ZERO).x
			
			GameGlobals.players[0].global_position.x += p2_wall_clip * p1_facing
			GameGlobals.players[1].global_position.x += p1_wall_clip * p2_facing
		
		GameGlobals.players[0].stage_collisions()
		GameGlobals.players[1].stage_collisions()
		
		var center = get_center()
		
		if center.x - GameGlobals.WallDistanceMax/2 < - GameGlobals.StageDistance/2:
			GameGlobals.StageLeft = - GameGlobals.StageDistance/2
			GameGlobals.StageRight = - GameGlobals.StageDistance/2 + GameGlobals.WallDistanceMax
		elif center.x + GameGlobals.WallDistanceMax/2 > GameGlobals.StageDistance/2:
			GameGlobals.StageLeft = GameGlobals.StageDistance/2 - GameGlobals.WallDistanceMax
			GameGlobals.StageRight = GameGlobals.StageDistance/2
		else:
			GameGlobals.StageLeft = center.x - GameGlobals.WallDistanceMax/2
			GameGlobals.StageRight = center.x + GameGlobals.WallDistanceMax/2
		
		camera.distance = get_distance()
