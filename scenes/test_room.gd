extends Node2D

const PLAYER_SCENE := preload(Constants.CharacterPaths[0])
const PLAYER_COLLISIONS := preload("res://scripts/player_collisions.gd")
const CAMERA_SCENE := preload("res://scripts/camera.gd")

var collisions
var camera

var hitstop := 0

func _ready():
	load_players()
	collisions = PLAYER_COLLISIONS.new()
	camera = CAMERA_SCENE.new()
	$GameLayer.add_child(collisions)
	$GameLayer.add_child(camera)
	collisions.connect("player_hit", on_player_hit)
	
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
			$GameLayer.add_child(Globals.players[0])
			$GameLayer.add_child(player)
	
func reset_players():
	pass

func on_player_hit(p1_hit, p2_hit, clashing, p1_attack, p2_attack):
	if hitstop > 0:
		return
	if clashing:
		Globals.players[0].hit_confirmed = true
		Globals.players[1].hit_confirmed = true
	else:
		for i in range(0, 2):
			var hitter : CharacterObject
			var victim : CharacterObject
			var attack : ActionState
			if i == 0:
				if p1_hit == null:
					continue
				hitter = Globals.players[0]
				victim = Globals.players[1]
				attack = p1_attack
			elif i == 1:
				if p2_hit == null:
					continue
				hitter = Globals.players[1]
				victim = Globals.players[0]
				attack = p2_attack
			if attack.hits == 0:
				continue
			hitter.hit_confirmed = true
			var dir = sign(victim.global_position.x - hitter.global_position.x)
			if !victim.in_corner():
				victim.velocity.x = attack.push_back * dir
			else:
				hitter.velocity.x = attack.push_back * -dir
			hitter.hitstop = attack.hitstop
			victim.hitstop = attack.hitstop
			attack.hits -= 1
			hitstop = attack.hitstop

func _physics_process(delta):
	if hitstop > 0:
		hitstop -= 1
