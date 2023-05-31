extends Node2D

@onready var round_timer = $RoundTimer
@onready var hud_layer = $HUDLayer
@onready var game_layer = $GameLayer
@onready var callout_layer = $CalloutLayer
@onready var frame_layer = $FrameLayer

const PLAYER_SCENE := preload(Constants.CharacterPaths[0])
const PLAYER_COLLISIONS := preload("res://scripts/player_collisions.gd")
const CAMERA_SCENE := preload("res://scripts/camera.gd")

var collisions
var camera

var hitstop := 0
var hit_delay := 0

var running := -1
var round := 0

var player_data = []

func _ready():
	load_players()
	start_round()
	collisions = PLAYER_COLLISIONS.new()
	camera = CAMERA_SCENE.new()
	$GameLayer.add_child(collisions)
	$GameLayer.add_child(camera)
	collisions.connect("player_hit", on_player_hit)
	
	
func load_players():
	Globals.players.clear()
	
	var center = (Globals.StageRight + Globals.StageLeft)/2.0
	
	for i in range(0, 2):
		var player = PLAYER_SCENE.instantiate()
		player.id = i + 1
		Globals.players.append(player)
		
		player_data.append({
			"combo_hits" : 0, 
			"combo_damage" : 0,
			"max_combo_damage" : 0,
			"proration" : 1.0,
			"wins" : 0,
		})
		
		if i == 1:
			Globals.players[0].nemesis = player
			player.nemesis = Globals.players[0]
			$GameLayer.add_child(Globals.players[0])
			$GameLayer.add_child(player)
	
func reset_players():
	var center = (Globals.StageRight + Globals.StageLeft)/2.0
	Globals.limit_left = -Globals.MAX_PLAYER_DISTANCE/2.0
	Globals.limit_right = Globals.MAX_PLAYER_DISTANCE/2.0
	
	for i in range(0, 2):
		var player = Globals.players[i]
		player.state_machine.change_state("Idle")
		player.health.value = player.health.max_health
		player.defense.value = player.defense.max_defense
		player.special.value = player.special.value/2
		player.velocity = Vector2.ZERO
		var height = player.push_box.shape.position.y + player.push_box.shape.size.y
		var offset = Globals.SPAWN_DISTANCE * (-1 if i == 0 else 1)
		player.position = Vector2(center + offset, Globals.StageBottom - height)
		if i == 1:
			Globals.players[0].face_target()
			Globals.players[1].face_target()
	
func start_round():
	running = -1	
	round += 1
	reset_players()
	callout_layer.round_start(round)
	round_timer.start(2.0)
	await round_timer.timeout
	running = 0
	Globals.players[0].state_machine.change_state("Standing")
	Globals.players[1].state_machine.change_state("Standing")
	round_timer.start(90.0)
	await round_timer.timeout
	if running == 0:
		end_round()
	
func end_round():
	running = 1
	
	var victor := -1
	for i in range(2):
		var player = Globals.players[i]
		var other_player = Globals.players[1] if i == 0 else Globals.players[0]
		
		if player.health.value > other_player.health.value:
			victor = i
		else:
			var other_data = player_data[1] if i == 0 else player_data[0]
			if player_data[i].wins < other_data.wins:
				victor = i
		
		if victor == i:
			player.state_machine.change_state("Victory")
			other_player.state_machine.change_state("Dead")
			player.special.use(35)
			player_data[i].wins += 1
			hud_layer.update_wins(i, player_data[i].wins)
			break
				
	if victor == -1:
		Globals.players[0].state_machine.change_state("Idle")
		Globals.players[1].state_machine.change_state("Idle")
	elif player_data[victor].wins >= 2:
		running = 2
	
	callout_layer.round_end(victor)
	round_timer.start(3.0)
	await round_timer.timeout
		
	if running == 1:	
		start_round()
	else:
		end_game()
	
func end_game():
	for i in Globals.players:
		i.queue_free()
	Globals.players.clear()
	player_data.clear()
	
func on_player_hit(p1_hit, p2_hit, clashing, p1_attack, p2_attack, is_projectile := false, projectile = null):
	if hitstop > 0:
		return
	if hit_delay > 0:
		return
	if Globals.players[0].state_machine.state.name == "Dead" or Globals.players[1].state_machine.state.name == "Dead":
		return
	
	if p1_attack is ActionState and p2_attack is ActionState:
		if p1_attack.is_a_grab or p2_attack.is_a_grab:
			clashing = false
	
	if clashing:
		if p1_attack.hits > 0 or p2_attack.hits > 0:
			Globals.players[0].hit_confirmed = true
			Globals.players[1].hit_confirmed = true
			Globals.players[0].hitstop = 30
			Globals.players[1].hitstop = 30
			p1_attack.hits -= 1
			p2_attack.hits -= 1
			Globals.players[0].effects.spawn_effect(p1_hit, "impact", 1.0, Globals.players[0].flipped)
			camera.shaker.shake(80.0)
	else:
		var p1_grab := false
		var p2_grab := false
		
		for i in range(0, 2):
			var hitter : CharacterObject
			var victim : CharacterObject
			var attack : CharacterState
			var attack_2 : CharacterState
			var pos : Vector2
			
			if i == 0:
				if p1_hit == null:
					continue
				hitter = Globals.players[0]
				victim = Globals.players[1]
				attack = p1_attack
				attack_2 = p2_attack
				pos = p1_hit
			elif i == 1:
				if p2_hit == null:
					continue
				hitter = Globals.players[1]
				victim = Globals.players[0]
				attack = p2_attack
				attack_2 = p1_attack
				pos = p2_hit
			if attack is ActionState == false:
				continue
			if !is_projectile and attack.hits == 0:
				continue
			elif is_projectile and projectile.hits == 0:
				continue
				
			var on_hit = victim.on_hit(attack)
			var hit_confirmed := false
			var grabbing := false
			
			if on_hit and attack is ActionState:	
				if (attack.is_a_grab or (attack.is_a_command_grab and on_hit != "Blocking")) and victim.grounded() and on_hit != "HardKnockdown":
					var can_grab := !victim.grab_immune
					if attack_2 is ActionState:
						can_grab = attack_2.is_a_grab != attack.is_a_grab
					if victim.hitstun > 0:
						can_grab = false
						
					if i == 0:
						p1_grab = can_grab
						grabbing = true
					elif i == 1:
						p2_grab = can_grab
						grabbing = true
				elif (!attack.is_a_grab):
					if (victim.grounded() and victim.hard_knockdown and attack.otg) or !victim.hard_knockdown or (victim.hard_knockdown and !victim.grounded()):
						hit_confirmed = true
			
			if grabbing:
				if p1_grab and p2_grab:
					hitter.state_machine.change_state("ThrowClash")
					victim.state_machine.change_state("ThrowClash")
				elif p1_grab != p2_grab:
					hitter = Globals.players[0] if p1_grab else Globals.players[1]
					victim = Globals.players[1] if p1_grab else Globals.players[0]
					attack = p1_attack if p1_grab else p2_attack
					hitter.state_machine.change_state(attack.throw_state)
					victim.state_machine.change_state(attack.grabbed_state)
					hit_confirmed = true
			
			if !attack.is_a_grab and hit_confirmed:
				var state = victim.state_machine.state
				if state is ActionState and state.is_a_grab:
					if victim.hit_box.get_boxes().size() > 0:
						hit_confirmed = false
					
			if hit_confirmed:
				if hit_delay == 0:
					var victim_state = victim.state_machine.state.name
					var in_combo = (victim.hitstun > 0 and victim_state != "Blocking") or victim_state == "Launched" or victim_state == "HardKnockdown"
					var damage = attack.damage 
					
					if !in_combo:
						player_data[i].combo_hits = 1
						player_data[i].proration = attack.proration
						player_data[i].combo_damage = damage
					else:
						if (player_data[i].proration > attack.proration or attack.force_proration):
							player_data[i].proration = attack.proration
						player_data[i].combo_hits += 1
						damage *= player_data[i].proration
						player_data[i].combo_damage += damage
						callout_layer.update_counter(i, player_data[i].combo_hits)
					
					if on_hit == "Blocking" and victim.defense.value > 0:
						victim.defense.take_damage(damage)
						victim.special.gain(attack.meter_gain / 2 + 2)
					else:
						victim.special.gain(damage / 10)
						victim.health.take_damage(damage)
								
					if player_data[i].max_combo_damage < player_data[i].combo_damage:
						player_data[i].max_combo_damage = player_data[i].combo_damage	
							
					victim.hitstop = attack.hitstop + attack.v_hitstop
					victim.hitstun = attack.blockstun if on_hit == "Blocking" else attack.hitstun
					if !is_projectile:	
						hitstop = attack.hitstop
						hitter.hit_confirmed = true
						hitter.hitstop = attack.hitstop
					
					if victim.punishable:
						callout_layer.update_counter(i, player_data[i].combo_hits, 1)
					elif victim.counterable:
						callout_layer.update_counter(i, player_data[i].combo_hits, 0)
					
					if !attack.is_a_grab:
						var push_back = attack.push_back_block if on_hit == "Blocking" else attack.push_back
						var dir = sign(victim.global_position.x - hitter.global_position.x)
						if !victim.in_corner():
							victim.velocity.x = push_back * dir
						elif !is_projectile:
							hitter.velocity.x = push_back * -dir
						if victim.hard_knockdown and attack.otg:
							victim.hard_knockdown = false
							victim.state_machine.change_state("Launched")
						elif !victim.hard_knockdown:
							if victim.state_machine.state.name == on_hit:
								victim.state_machine.state.enter()
							victim.state_machine.change_state(on_hit)
							
						if on_hit != "Blocking":
							if (!victim.grounded() or attack.launch_on_hit):
								if victim_state != "HardKnockdown":
									victim.hard_knockdown = attack.hard_knockdown
								victim.velocity.y = -attack.launch_velocity
								victim.gravity_modifier = attack.gravity_modifier
					
					match attack.attack_level:
						0:
							camera.shaker.shake(25.0)
						1:
							camera.shaker.shake(35.0)
						2:
							camera.shaker.shake(50.0)
						3:
							camera.shaker.shake(80.0)
					
					var recovery_frames = (attack.startup_frames + attack.active_frames + attack.recovery_frames) - attack.frame
					var frame_advantage = victim.hitstun - recovery_frames 
					victim_state = victim.state_machine.state.name
					if victim_state == "Launched":
						if attack.hard_knockdown:
							frame_advantage += 55
						else:
							frame_advantage += 30
					frame_layer.update_data(i, player_data[i].combo_damage, player_data[i].max_combo_damage, player_data[i].combo_hits, player_data[i].proration * 100.0, frame_advantage)
					
					if !attack.is_a_grab:
						victim.effects.spawn_effect(pos, "impact" if on_hit != "Blocking" else "blocking", 1.0, victim.flipped)
					
				if attack.hits > 1:
					hit_delay = attack.hit_delay
				hitter.special.gain(attack.meter_gain)
				if projectile:
					if projectile.hits > 1:
						hit_delay = attack.hit_delay
					projectile.hitstop = attack.hitstop
					projectile.hits -= 1
				else:
					attack.hits -= 1
	
	for i in Globals.players:
		if i.is_dead():
			end_round()
			break
					

func _physics_process(delta):
	if hitstop > 0:
		hitstop -= 1
	elif hit_delay > 0:
		hit_delay -= 1
	if Globals.players.size() > 1:
		hud_layer.update_bars(Globals.players[0], Globals.players[1])
		if running == 0:
			hud_layer.update_timer(int(round_timer.time_left))
