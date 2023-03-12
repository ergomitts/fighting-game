extends GameObject
class_name CharacterObject

@export_category("Character Movement Settings") 
@export var front_speed := 0.0
@export var back_speed := 0.0
@export var fdash_velocity := 0.0 
@export var bdash_velocity := 0.0
@export var dash_friction := 0.0
@export var gravity := 0.0

@export var push_box : CollisionBox
@export var state_machine : StateMachine

var stance : GameConstants.CharacterStance
var hitstun := 0

func _ready():
	state_machine.init()

func move_and_collide(dir: Vector2, other: CollisionBox):
	move(dir)
	var intersection = push_box.is_colliding_with(other)
	if abs(intersection) > 0:
		move(Vector2(-intersection, 0))

func apply_limits():
	var center = push_box.get_center()
	var top = center.y - push_box.shape.size.y/2
	var bottom = center.y + push_box.shape.size.y/2
	var left = center.x - push_box.shape.size.x/2
	var right = center.x + push_box.shape.size.x/2
	
	if top < Globals.StageTop:
		position.y += Globals.StageTop - top
		velocity.y = 0
	if bottom > Globals.StageBottom:
		position.y += Globals.StageBottom - bottom
		velocity.y = 0
	if left < Globals.StageLeft:
		position.x += Globals.StageLeft - left
		velocity.x = 0
	if right > Globals.StageRight:
		position.x += Globals.StageRight - right
		velocity.x = 0
	
func _update_physics(delta: float):
	velocity.y += 0.5
	velocity.x += 0.05
	move_and_collide(velocity, get_parent().get_node("BB"))
	apply_limits()
	

