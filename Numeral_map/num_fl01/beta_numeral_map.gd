extends Node3D

@export var player: CharacterBody3D
@onready var animation_player: AnimationPlayer = $PrototypeMap_1/ButtonFloorOne/AnimationPlayer

#stage_timer
var timer_running := false
var local_timer := 0.0

@onready var timer_label: Label = %TimerLabel
@onready var tier_label: Label = %TierLabel



func _ready() -> void:
	# เริ่มจับเวลาเมื่อเริ่มแมพ
	Dialogic.start("new_numeral_system_diallog","beginbinarylevel")
	timer_running = true
	local_timer = 0.0
	GameState.numeral_system_timer = 0.0
	
	Dialogic.signal_event.connect(_on_dialogic_signal)
	GameState.state_changed.connect(_on_key_update)
	#Dialogic.start("timeline")
	
	
	
	# Apply Viewport settings
	get_viewport().scaling_3d_scale = GlobalSettings.render_scale
	get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA if GlobalSettings.use_fxaa else Viewport.SCREEN_SPACE_AA_DISABLED
	get_viewport().use_taa = GlobalSettings.use_taa
	get_viewport().msaa_3d = GlobalSettings.msaa_index

	# Apply WorldEnvironment (ถ้ามี)
	if $WorldEnvironment:
		$WorldEnvironment.environment.ssao_enabled = GlobalSettings.ssao_enabled
		$WorldEnvironment.environment.volumetric_fog_enabled = GlobalSettings.fog_enabled
		$WorldEnvironment.environment.adjustment_saturation = 1.02 if GlobalSettings.fog_enabled else 0.95
		$WorldEnvironment.environment.adjustment_contrast = 1.02 if GlobalSettings.fog_enabled else 0.95

	# Apply VSync
	var vsync_mode = DisplayServer.VSYNC_ENABLED if GlobalSettings.vsync_enabled else DisplayServer.VSYNC_DISABLED
	DisplayServer.window_set_vsync_mode(vsync_mode)
	
func _process(delta: float) -> void:
	GameState.numeral_system_timer = local_timer
	if timer_running:
		local_timer += delta
		GameState.numeral_system_timer = local_timer
	
		var minutes = int(local_timer / 60)
		var seconds = int(local_timer) % 60
		timer_label.text = "Time: %02d:%02d" % [minutes, seconds]
		tier_label.text =  "Tier : " + GameState.numeral_system_tier
	
func _on_dialogic_signal(argument: String):
	if argument == "gg":
		pass
		
		
func _on_key_update(key, value):
	#1
	if key == "key" and value == 1:
		print("Key equal to 1")
		Dialogic.start("new_numeral_system_diallog","firstkeycollected")
	#2
	if key == "key" and value == 2:
		print("Key equal to 2")
		animation_player.play("to_octal")
		player.shake_camera(3.0, 0.2, 1.3)
		Dialogic.start("new_numeral_system_diallog","secondkeyscollected")
	#3
	if key == "key" and value == 3:
		print("Key equal to 3")
		Dialogic.start("new_numeral_system_diallog","thirdkeyscollected")
	#4
	if key == "key" and value == 4:
		print("Key equal to 4")
		Dialogic.start("new_numeral_system_diallog","fourthkeyscollected")
	#5
	if key == "key" and value == 5:
		print("Key equal to 5")
		Dialogic.start("new_numeral_system_diallog","fifthkeyscollected")
	#6
	if key == "key" and value == 6:
		print("Key equal to 6")
		Dialogic.start("new_numeral_system_diallog","sixthkeyscollected")
	#7
	if key == "key" and value == 7:
		print("Key equal to 7")
		Dialogic.start("new_numeral_system_diallog","seventhkeyscollected")
	#8
	if key == "key" and value == 8:
		print("Key equal to 8")
		Dialogic.start("new_numeral_system_diallog","eightthkeyscollected")
	#9
	if key == "key" and value == 9:
		print("Key equal to 9")
		Dialogic.start("new_numeral_system_diallog","ninethkeyscollected")
	#10
	if key == "key" and value == 10:
		print("Key equal to 10")
		Dialogic.start("new_numeral_system_diallog","tenthkeyscollected")
	#11
	if key == "key" and value == 11:
		print("Key equal to 11")
		Dialogic.start("new_numeral_system_diallog","eleventhkeyscollected")
	#12
	if key == "key" and value == 12:
		print("Key equal to 12")
		Dialogic.start("new_numeral_system_diallog","twelfthkeyscollected")
	#13
	if key == "key" and value == 13:
		print("Key equal to 13")
		player.shake_camera(4.0, 0.2, 2.3)
		timer_running = false
		evaluate_tier_from_timer()
		Dialogic.start("new_numeral_system_diallog","thirteenkeyscollected")
		await Dialogic.timeline_ended
		await get_tree().create_timer(2.0).timeout
		Dialogic.start("new_numeral_system_diallog","aftercollectallkeys")
		await Dialogic.timeline_ended
		await get_tree().create_timer(2.0).timeout
		Dialogic.start("new_numeral_system_diallog","finaldialogue")
		await Dialogic.timeline_ended
		await get_tree().create_timer(5.0).timeout
		LoaderManager.change_level("res://newgen_assets/Lobby_all/main_character_menu.tscn")
			
func evaluate_tier_from_timer():
	var time = GameState.numeral_system_timer
	
	if time == null:
		print("❌ Timer value is null!")
		return
	
	var tier = "Unranked"

	if time <= 12 * 60:
		tier = "S"
	elif time <= 15 * 60:
		tier = "A"
	elif time <= 20 * 60:
		tier = "B"
	else:
		tier = "C"

	GameState.numeral_system_tier = tier
	#tier_label.text = "Tier: %s" % tier
	tier_label.text =  "Tier : " + GameState.numeral_system_tier
	print("✅ Tier for this map: ", tier)
