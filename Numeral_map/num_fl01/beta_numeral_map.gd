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
	
	
func _on_dialogic_signal(argument: String):
	if argument == "gg":
		pass
		
		
func _on_key_update(key, value):
	if key == "key" and value == 2:
		print("Key equal to 2")
		animation_player.play("to_octal")
		player.shake_camera(3.0, 0.2, 1.3)
	
	if key == "key" and value == 4:
		print("Key equal to 4")
	
	if key == "key" and value == 8:
		print("Key equal to 8")
		
	if key == "key" and value == 13:
		print("Key equal to 13")
		player.shake_camera(4.0, 0.2, 2.3)
		timer_running = false
		evaluate_tier_from_timer()

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
	tier_label.text = "Tier: %s" % tier
	print("✅ Tier for this map: ", tier)
