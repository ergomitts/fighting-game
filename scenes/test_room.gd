extends Node2D

const PLAYER_SCENE := preload(Constants.CharacterPaths[0])
const CAMERA_SCENE := preload("res://scripts/camera.gd")
const PLAYER_COLLISIONS := preload("res://scripts/player_collisions.gd")

func _ready():
	load_players()
	add_child(PLAYER_COLLISIONS.new())
	add_child(CAMERA_SCENE.new())
	
func load_players():
	Globals.players.clear()
	
	var center = (Globals.StageRight + Globals.StageLeft)/2
	
	for i in range(0, 2):
		var player = PLAYER_SCENE.instantiate()
		player.id = i + 1
		Globals.players.append(player)
		
		var height = player.push_box.shape.position.y + player.push_box.shape.size.y
		var offset = Globals.SPAWN_DISTANCE * (-1 if i == 0 else 1)
		player.position = Vector2(center + offset, Globals.StageBottom - height)
		
		if i == 1:
			Globals.players[0].nemesis = player
			player.nemesis = Globals.players[0]
			add_child(Globals.players[0])
			add_child(player)
	
func reset_players():
	pass
