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
@export var ground := true
@export var aerial := false
@export var crouch := false
@export var attack_type : Constants.AttackType
@export var force_stance := ""
@export var hard_knockdown := false
@export var is_a_grab := false
@export var is_a_command_grab := false
@export var grabbed_state := ""
@export var throw_state := ""
@export var is_a_throw := false
@export var proration := 1.0
@export var force_proration := false
@export var max_uses_in_combos := -1
@export var damage := 100
@export var chip_damage := 0
@export var push_back := 100
@export var push_back_block := 50
@export var launch_on_hit := false
@export var launch_velocity := 50
@export var wall_bounce := false
@export var meter_gain := 0
@export var meter_usage := 0
@export var attack_level := 0
@export var gravity_modifier := 1.0
@export var otg := false
@export var hit_delay := 0
@export var jump_cancelable := false
@export var spawn_projectile := false
@export var projectile_speed := 10.0
@export var projectile_hit_amount := 1
@export var projectile_lifetime := 5.0
@export var is_finisher := false

@export_category("States")
@export var can_cancel_startup := false
@export var cancel_into : PackedStringArray
@export var hit_amount := 1

var frame := 0
var hits := 0

func enter():
	hits = hit_amount
	frame = 0
	host.animation_player.stop()
	host.animation_player.play(animation)
	host.counterable = true
	host.punishable = false
	host.special.use(meter_usage)
	if !host.hit_confirmed and host.grounded():
		host.velocity.x = 0.0
	host.hit_confirmed = false
	host.crouching = crouch
	if is_a_grab:
		host.velocity.x = 0.0
	if is_a_throw:
		if is_holding_away():
			host.flipped = not host.flipped
			host.nemesis.global_position = host.sprite_container.get_node("GrabPosition").global_position
			host.face_target()
			host.nemesis.face_target()
			if host.in_corner():
				host.position.x += -(host.push_box.shape.size.x) * host.get_corner()
	
func exit():
	host.animation_player.stop()
	host.counterable = false
	host.punishable = false
	host.hit_confirmed = false
	host.crouching = crouch
	
func physics_process(delta):
	process_physics(delta)
	if aerial and host.grounded():
		return "Landing"
	if host.hit_confirmed:
		if is_a_grab:
			return throw_state
		else:
			host.crouching = get_axis().y == 1
			var controller := InputManager.controllers[host.id - 1] as Controller
			if (get_axis().y == -1 and jump_cancelable and host.jumps > 0) or (is_a_throw and controller.read_motion_input(Constants.MotionInput.HalfCircleF_GG, host.flipped)):
				host.velocity.x = 0.0
				return "Prejump"
			var state = process_input()
			if state:
				if state in cancel_into:
					if state == name:
						enter()
					else:
						return state
	if frame > startup_frames + active_frames + recovery_frames:
		if !host.grounded():
			return "Aerial"
		else:
			return "Grounded"
	if frame >= startup_frames + active_frames:
		host.counterable = false
		host.punishable = true		
	if frame < startup_frames:
		if can_cancel_startup:
			var controller := InputManager.controllers[host.id - 1] as Controller
			if controller.check_combined_buttons(["light", "medium"]):
				return "Grab"
	if frame == startup_frames and spawn_projectile:
		host.projectiles.spawn_projectile(host.sprite_container.get_node("ProjectilePosition").global_position, self, host.flipped)
	frame += 1			
	
	
