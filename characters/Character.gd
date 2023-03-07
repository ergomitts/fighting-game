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

func get_corner(velocity := 0.0):
	var side = 0
	if push_box.right_global() + velocity >= GameGlobals.StageRight:
		side = 1
	elif push_box.left_global() + velocity <= GameGlobals.StageLeft:
		side = -1
	return side

func snap_to_corner(_velocity):
	if get_corner(_velocity.x) == 1:
		_velocity.x -= push_box.right_global() + _velocity.x - GameGlobals.StageRight
	if get_corner(_velocity.x) == -1:
		_velocity.x -= push_box.left_global() + _velocity.x - GameGlobals.StageLeft	
	return _velocity

func move_and_push(_velocity, enemy = null):	
	if enemy and enemy.get('push_box'):
		var enemy_rect := enemy.push_box.get_global_rect() as Rect2	
		var projected_rect := Rect2(push_box.get_center() + _velocity, push_box.shape.size)
		
		if projected_rect.intersects(enemy_rect):
			var center = projected_rect.position.x + projected_rect.size.x/2
			var clip = (push_box.left_global() + _velocity.x) - enemy.push_box.right_global()
			if center < enemy.push_box.global_position.x:
				clip = (push_box.right_global() + _velocity.x) - enemy.push_box.left_global()

			if enemy.get_corner() == 0:
				if abs(enemy.velocity.x) < abs(clip):
					enemy.move_and_push(Vector2(enemy.velocity.x + clip, 0))
				elif abs(enemy.velocity.x) > abs(clip):
					_velocity.x -= clip
				else:
					_velocity.x = 0
			else:
				if get_corner() == 1:
					clip = (push_box.right_global() + _velocity.x) - enemy.push_box.left_global()
				elif get_corner() == -1:
					clip = (push_box.left_global() + _velocity.x) - enemy.push_box.right_global()
				_velocity.x -= clip
	
	var up = push_box.up_global() + _velocity.y
	var down = push_box.down_global() + _velocity.y
			
	if down > GameGlobals.StageBottom:
		_velocity.y -= down - GameGlobals.StageBottom
	if up < GameGlobals.StageTop:
		_velocity.y -= up - GameGlobals.StageTop
	_velocity.x = snap_to_corner(_velocity).x	
	
	move(_velocity)
	return _velocity
	
func stage_collisions():
	var up = push_box.up_global()
	var down = push_box.down_global()
	
	if down > GameGlobals.StageBottom:
		global_position.y = GameGlobals.StageBottom - push_box.shape.size.y/2
		velocity.y = 0
	if up < GameGlobals.StageTop:
		global_position.y = GameGlobals.StageTop + push_box.shape.size.y/2
		velocity.y = 0
	if push_box.left_global() < GameGlobals.StageLeft:
		global_position.x = GameGlobals.StageLeft + push_box.shape.size.x/2
		velocity.x = 0
	if push_box.right_global() > GameGlobals.StageRight:
		global_position.x = GameGlobals.StageRight - push_box.shape.size.x/2
		velocity.x = 0
	
func update_physics(delta: float):
	velocity.y += gravity
#	velocity = move_and_push(velocity, enemy)
#	global_position += velocity

func get_state():
	return state_machine.current_state.name
