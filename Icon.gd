extends Sprite2D

@export var is_player = false
@export var other_player : Node2D
@export var speed := 5

var hitstop = 0
var hitstun = 0
var stunned = false
var blocking = false

var velocity : Vector2
	
func on_floor() -> bool:
	return global_position.y + 64 >= 500
	
func jump():
	if on_floor():
		velocity.y = -70
		
func hurt():
	hitstop = 15
	hitstun = 10
	stunned = true
	velocity.x = -72 if facing_right() else 72
	velocity.y = -45

func is_blocking():
	var dir = 0
	if is_player:
		dir = Input.get_axis("left_1", "right_1")
	else:
		dir = Input.get_axis("left_2", "right_2")
	if other_player.facing_right() and dir > 0:
		return true
	elif !other_player.facing_right() and dir < 0:
		return true
	return false

func check_wall_bounce():
	if on_floor():
		return
	if global_position.x - 64 <= get_parent().wall_left:
		velocity.x = 10
		velocity.y = -10
	elif global_position.x + 64 >= get_parent().wall_right:
		velocity.x = -10
		velocity.y = -10

func punch():
	var hitbox = Rect2(global_position + Vector2(64, -64), Vector2(35, 45))
	if !facing_right():
		hitbox = Rect2(global_position + Vector2(-99, -64), Vector2(35, 45))
	var hurtbox = Rect2(other_player.global_position - Vector2(64, 64), Vector2(128, 128))
	if hitbox.intersects(hurtbox) and !other_player.is_blocking():
		other_player.hurt()
		hitstop = 15
	elif hitbox.intersects(hurtbox):
		hitstop = 8
		other_player.hitstop = 8
		velocity.x = -15 if facing_right() else 15
		
func facing_right():
	if global_position.x < other_player.global_position.x:
		return true
	elif global_position.x > other_player.global_position.x:
		return false
	else:
		return is_player

func handle_action(delta):
	var dir = 0
	if is_player:
		dir = Input.get_axis("left_1", "right_1")
		if Input.is_action_just_pressed("jump_1"):
			jump()
		if Input.is_action_just_pressed("punch_1"):
			punch()
	else:
		dir = Input.get_axis("left_2", "right_2")
		if Input.is_action_just_pressed("jump_2"):
			jump()
		if Input.is_action_just_pressed("punch_2"):
			punch()
	velocity.x = lerp(velocity.x, dir * speed, 5 * delta)

func _physics_process(delta):
	if hitstop > 0:
		hitstop -= 1
		modulate = Color.BLUE
	else:
		if !on_floor():
			if stunned:
				velocity.y += 2
			else:
				velocity.y += 4
		else:
			velocity.y = 0
		
		if hitstun > 0:
			hitstun -= 1
			check_wall_bounce()
			modulate = Color.RED
		else:
			if stunned and on_floor():
				stunned = false
			elif stunned:
				check_wall_bounce()
				modulate = Color.RED
			if !stunned:
				handle_action(delta)
				if is_player:
					modulate = Color.WHITE
				else:
					modulate = Color.GREEN
			
		position.y += velocity.y
		position.x += velocity.x
			
	
