extends Node
class_name Shaker

@onready var noise := FastNoiseLite.new()
@onready var rand := RandomNumberGenerator.new()

@export var shake_speed := 30.0
@export var default_strength := 60.0
@export var decay_rate := 3.0
@export var is_random := false

var strength := 0.0
var i := 0.0
var position := Vector2.ZERO

func _ready():
	rand.randomize()
	noise.seed = rand.randi()
	noise.frequency = 0.1
	
func _process(delta: float) -> void:
	strength = lerp(strength, 0.0, decay_rate * delta)
	var shake_offset: Vector2
	if is_random:
		shake_offset = get_random_offset()
	else:
		shake_offset = get_noise_offset(delta, shake_speed, strength)
	position = shake_offset
	
func shake(shake_strength := default_strength):
	strength = shake_strength
	
func get_noise_offset(delta: float, speed: float, strengthy: float) -> Vector2:
	i += delta * speed
	return Vector2(
		noise.get_noise_2d(1, i) * strengthy,
		noise.get_noise_2d(100, i) * strengthy
	)

func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-strength, strength),
		rand.randf_range(-strength, strength)
	)
