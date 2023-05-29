extends CanvasLayer

@onready var frame_data_viewer := $FrameDataViewer
@onready var status1 := get_node("%PlayerStatus1")
@onready var status2 := get_node("%PlayerStatus2")

func update_data(index, combo_damage, max_combo_damage, combo_hits, proration, frame_adv):
	var status = status1 if index == 0 else status2
	var damage_label := status.get_node("Damage")
	var max_combo_label := status.get_node("MaxComboDamage")
	var combo_label := status.get_node("ComboHits")
	var proration_label := status.get_node("Proration")
	var frame_adv_label := status.get_node("FrameAdvantage")
	
	damage_label.text = "Damage: " + str(combo_damage)
	max_combo_label.text = "Max Damage: " + str(max_combo_damage)
	combo_label.text = "Combo Hits: " + str(combo_hits)
	proration_label.text = "Proration: " + str(proration) + "%"
	frame_adv_label.text = "Frame Adv: " + ("-" if frame_adv < 0 else "+") + str(frame_adv)
	
func update_frame_data(player: CharacterObject, index := 0):
	var status = status1 if index == 0 else status2
	var state_label := status.get_node("State")
	var frame_label := status.get_node("Frame")
	
	var stun_label := status.get_node("Stun")
	
	var state = player.state_machine.state
	if state != null:
		state_label.text = "State: " + str(state.name).capitalize()
		frame_label.text = "Frame: " + str(player.animation_pos_in_frames()) + "/" + str(player.animation_length_in_frames())
		stun_label.text = "Stun: " + str(player.hitstun)
	
func _process(delta):
	if Input.is_action_just_pressed("toggle_frame_data_display"):
		visible = not visible
	if visible:
		for i in range(Globals.players.size()):
			update_frame_data(Globals.players[i], i)
