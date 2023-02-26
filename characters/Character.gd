extends GameObject
class_name Character

enum CharacterStance {
	Grounded,
	Crouching,
	Aerial,
	OTG
}

export var c_Character_Stats = 0
export(float, 0.0, 50.0) var gravity_default := 1.6

onready var push_box := $PushBox
onready var hurt_box := $HurtBox
onready var state_machine := $StateMachine
onready var sprite_container := $SpriteContainer
onready var animation_player := $AnimationPlayer

var controller
var enemy

var current_state setget , get_state

var stance = CharacterStance.Grounded
var velocity := Vector2.ZERO
var gravity := gravity_default
var facing := 1
var id := 0

func _ready():
	state_machine.init(state_machine.init_state)

func flip():
	facing *= -1
	sprite_container.scale.x = facing
	
func update_physics(delta: float):
	velocity.y += gravity
	velocity = push_box.move_and_push(velocity, enemy.push_box)
	move(velocity)

func get_state():
	return state_machine.current_state.name
