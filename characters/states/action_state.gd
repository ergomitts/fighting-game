extends CharacterState
class_name ActionState

@export_category("Inputs")
@export var motion := Constants.MotionInput.Empty
@export var direction := Vector2(0, 0)
@export var button := Constants.Buttons.Light
@export var can_special := false

@export_category("Frame Data")
@export var animation := ""
@export var startup_frames := 0
@export var active_frames := 0
@export var recovery_frames := 0
@export var hitstun := 0
@export var blockstun := 0
@export var hitstop := 0
@export var v_hitstop := 0

@export_category("Attributes")
@export var aerial := false
@export var crouch := false
@export var attack_type : Constants.AttackType
@export var force_stance : Constants.Stance
@export var hard_knockdown := false
@export var is_a_grab := false
@export var proration := 1.0
@export var max_uses_in_combos := -1
@export var damage := 100
@export var chip_damage := 0
@export var push_back := 100
@export var push_back_block := 50
@export var launch_on_hit := false
@export var launch_velocity := 50
@export var max_wall_bounce := 0
@export var max_ground_bounce := 0
@export var meter_gain := 25
@export var attack_level := 0

@export_category("States")
@export var can_cancel_startup := false
@export var cancel_into : PackedStringArray
@export var hit_amount := 1

var frame := 0
var hits := 0

func enter():
	hits = hit_amount
	frame = 0
	host.animation_player.play(animation)
	host.counterable = true
	host.crouching = crouch
	
func exit():
	host.animation_player.stop()
	host.hit_confirmed = false
	host.hit_box.clear()
	host.counterable = false
	host.punishable = false
	host.crouching = crouch
	
func physics_process(delta):
	process_physics(delta)
	if aerial and host.grounded():
		return "Landing"
	if host.hit_confirmed:
		host.crouching = get_axis().y == 1
		var state = process_input()
		if state:
			if state in cancel_into:
				if state == name:
					exit()
					enter()
				else:
					return state
	if host.animation_finished():
		if aerial:
			return "Aerial"
		else:
			return "Grounded"
	frame += 1
	if frame >= startup_frames + active_frames:
		host.counterable = false
		host.punishable = true
