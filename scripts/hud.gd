extends CanvasLayer

@onready var main := $Main
@onready var health1 := $Main/Health1
@onready var health2 := $Main/Health2
@onready var defense1 := $Main/Defense1 
@onready var defense2 := $Main/Defense2
@onready var special1 := $Main/Special1
@onready var special2 := $Main/Special2
@onready var timer_label := $Main/TimerLabel

func _ready():
	pass
	
func update_bars(player1: CharacterObject, player2: CharacterObject):
	health1.max_value = player1.health.max_health
	health2.max_value = player2.health.max_health
	health1.value = player1.health.value
	health2.value = player2.health.value
	
	defense1.max_value = player1.defense.max_defense
	defense2.max_value = player2.defense.max_defense
	defense1.value = player1.defense.value
	defense2.value = player2.defense.value
	
	special1.max_value = player1.special.max_value
	special2.max_value = player2.special.max_value
	special1.value = player1.special.value
	special2.value = player2.special.value
	
func update():
	pass
