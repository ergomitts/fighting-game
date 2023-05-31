extends GameObject

@onready var timer := $Timer
@export var hit_box : Node
@export var despawn_time := 5.0
@export var speed := 10.0

var attack : ActionState
var hits := 5

func _ready():
	animation_player.play("default")
	timer.one_shot = true
	timer.start(despawn_time)
	timer.connect("timeout", despawn)
	velocity.x = speed
	
func _flip(value):
	flipped = value
	sprite_container.scale.x = -1 if flipped else 1
	if flipped:
		velocity.x *= -1
	
func despawn():
	queue_free()

func physics_process(delta: float):
	if hits > 0:
		move(velocity)
	else:
		despawn()
