extends Node2D

const PLAYER_SCENE := preload(Constants.CharacterPaths[0])

var players := []

func _ready():
	load_players()

func load_players():
	players.clear()
	
	var center = (Globals.StageRight + Globals.StageLeft)/2
	
	for i in range(0, 2):
		var player = PLAYER_SCENE.instantiate()
		player.id = i + 1
		players.append(player)
		
		var height = player.push_box.shape.position.y + player.push_box.shape.size.y
		var offset = Globals.SPAWN_DISTANCE * (-1 if i == 0 else 1)
		player.position = Vector2(center + offset, Globals.StageBottom - height)
		
		if i == 1:
			players[0].nemesis = player
			player.nemesis = players[0]
			add_child(players[0])
			add_child(player)
	
func reset_players():
	pass
