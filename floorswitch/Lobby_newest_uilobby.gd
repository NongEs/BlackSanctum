extends CanvasLayer
@export var dec_to_bi_scene: PackedScene
@export var logic_gate_scene: PackedScene
var showing_menu := false
var showing_menu_setting := false
var showing_menu_artifact := false
@onready var tier_label: Label = %TierLabel
@onready var time_best: Label = %TimeBest

func _enter_tree():
	%TopicM.modulate.a = 0.0
	%SettingM.modulate.a = 0.0
	%ArtifactM.modulate.a = 0.0
func _ready() -> void:
	#"Tier: " +
	#"Best Time:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	tier_label.text =  GameState.numeral_system_tier
	time_best.text = " %.2f s" % GameState.numeral_system_timer
	%MSAAOptionButton.add_item("Disabled", 0)
	%MSAAOptionButton.add_item("2x", 1)
	%MSAAOptionButton.add_item("4x", 2)
	%MSAAOptionButton.add_item("8x", 3)
	%MSAAOptionButton.select(0)
	%GeneralQualityOptionButton.add_item("Low", 0)
	%GeneralQualityOptionButton.add_item("Medium", 1)
	%GeneralQualityOptionButton.add_item("High", 2)
	%GeneralQualityOptionButton.add_item("Ultra", 3)
	%GeneralQualityOptionButton.select(2)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	_on_general_quality_option_button_item_selected(2)

func _physics_process(delta):
	%FPSLabel.text = "FPS: %s" % Engine.get_frames_per_second()
	
func _on_next_button_pressed() -> void:
	show_menu(!showing_menu)
	print("Next button pressed")

# Show or hide the menu
var menu_tween : Tween
func show_menu(_show: bool):
	showing_menu = _show
	if not showing_menu:
		if menu_tween:
			menu_tween.kill()
		menu_tween = get_tree().create_tween()
		menu_tween.tween_property(%TopicM, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		# Use Callable to pass the function reference
		menu_tween.tween_callback(Callable(self, "_on_menu_hidden")).set_delay(0.2)
		%SettingButton.show()
		%ArtifactButton.show()
	else:
		%TopicM.show()
		%CharacterButton.hide()
		%ArtifactButton.hide()
		%SettingButton.hide()
		%ArtifactM.hide()
		if menu_tween:
			menu_tween.kill()
		menu_tween = get_tree().create_tween()
		menu_tween.tween_property(%TopicM, "modulate:a", 1, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

# Callback function for when the menu is hidden
func _on_menu_hidden():
	%TopicM.hide()
	
func _on_setting_button_pressed() -> void:
	print("Setting button pressed")
	setting_show_menu(!showing_menu_setting)
# Show or hide the setting menu
var setting_menu_tween : Tween
func setting_show_menu(_showsetting: bool):
	showing_menu_setting = _showsetting
	if not showing_menu_setting:
		if setting_menu_tween:
			setting_menu_tween.kill()
		setting_menu_tween = get_tree().create_tween()
		setting_menu_tween.tween_property(%SettingM, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		%NextButton.show()
		%ArtifactButton.show()
		# Use Callable to pass the function reference
		setting_menu_tween.tween_callback(Callable(self, "_on_setting_menu_hidden")).set_delay(0.2)
	else:
		%SettingM.show()
		%CharacterButton.hide()
		%ArtifactButton.hide()
		%SettingButton.show()
		%NextButton.hide()
		if setting_menu_tween:
			setting_menu_tween.kill()
		setting_menu_tween = get_tree().create_tween()
		setting_menu_tween.tween_property(%SettingM, "modulate:a", 1, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
# Callback function for when the setting menu is hidden
func _on_setting_menu_hidden():
	%SettingM.hide()
	
var artifact_menu_tween : Tween
func _on_artifact_button_pressed() -> void:
	artifact_show_menu(!showing_menu_artifact)
	print("Artifact button pressed")
	
func artifact_show_menu(_showartifact: bool):
	showing_menu_artifact = _showartifact
	if not showing_menu_artifact:
		if artifact_menu_tween:
			artifact_menu_tween.kill()
		artifact_menu_tween = get_tree().create_tween()
		artifact_menu_tween.tween_property(%ArtifactM, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		%ArtifactButton.show()
		%NextButton.show()
		
		# Use Callable to pass the function reference
		artifact_menu_tween.tween_callback(Callable(self, "_on_artifact_menu_hidden()")).set_delay(0.2)
	else:
		%SettingM.hide()
		%ArtifactM.show()
		%CharacterButton.hide()
		%ArtifactButton.show()
		%SettingButton.hide()
		%NextButton.hide()
		
		if artifact_menu_tween:
			artifact_menu_tween.kill()
		artifact_menu_tween = get_tree().create_tween()
		artifact_menu_tween.tween_property(%ArtifactM, "modulate:a", 1, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
# Callback function for when the setting menu is hidden
		
		
		
func _on_artifact_menu_hidden():
	%ArtifactM.hide()
# Function to handle setting button press



func _on_settings_button_pressed() -> void:
	%UI.hide()
	%Settings.show()
	%WFullScreenCheckBox.grab_focus()


func _on_close_settings_button_pressed() -> void:
	%UI.show()
	%Settings.hide()
	%ResumeButton.grab_focus()
	
func _on_quit_button_pressed():
	var tween = get_tree().create_tween()
#	tween.tween_property($WorldEnvironment.environment, "adjustment_brightness", 0.01, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(%SettingM, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_method(func(v):AudioServer.set_bus_volume_db(0, v), 0, -24, 0.5)
	tween.finished.connect(func():get_tree().quit())


func _on_w_full_screen_check_box_pressed():
	if %FullScreenCheckBox.button_pressed:
		%FullScreenCheckBox.button_pressed = false
	if %WFullScreenCheckBox.button_pressed:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_full_screen_check_box_pressed():
	if %WFullScreenCheckBox.button_pressed:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		%WFullScreenCheckBox.button_pressed = false
	if %FullScreenCheckBox.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_fps_check_box_pressed():
	%FPSLabel.visible = %FPSCheckBox.button_pressed


func _on_cinematic_check_box_pressed():
	%BlackBarTop.visible = %CinematicCheckBox.button_pressed
	%BlackBarBottom.visible = %CinematicCheckBox.button_pressed


func _on_fxaa_button_pressed():
	get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA if %FXAAButton.button_pressed else Viewport.SCREEN_SPACE_AA_DISABLED
	GlobalSettings.use_fxaa = %FXAAButton.button_pressed

func _on_temporal_button_pressed():
	get_viewport().use_taa = %TemporalButton.button_pressed
	GlobalSettings.use_taa = %TemporalButton.button_pressed

func _on_render_resolution_slider_value_changed(value):
	%RenderResolutionLabel.text = "Render Scale: %s%%" % str(round(value*100))
	get_viewport().scaling_3d_scale = value
	%FXAAButton.disabled = value > 1.0
	GlobalSettings.render_scale = value

func _on_msaa_option_button_item_selected(index):
	get_viewport().msaa_3d = index
	GlobalSettings.msaa_index = index

var settings := {
	"positional_shadow_atlas_size": [1024, 2048, 4096, 8192],
	"pos_soft_shadow_filter_quality": [1, 2, 4, 4],
	"directional_shadow_atlas_size": [2048, 2048, 4096, 8192],
	"dir_soft_shadow_filter_quality": [1, 2, 4, 4],
	"ray_count": [
		RenderingServer.ENV_SDFGI_RAY_COUNT_16,
		RenderingServer.ENV_SDFGI_RAY_COUNT_32,
		RenderingServer.ENV_SDFGI_RAY_COUNT_64,
		RenderingServer.ENV_SDFGI_RAY_COUNT_128],
	"voxel_gi": [
		RenderingServer.VOXEL_GI_QUALITY_LOW,
		RenderingServer.VOXEL_GI_QUALITY_LOW,
		RenderingServer.VOXEL_GI_QUALITY_HIGH,
		RenderingServer.VOXEL_GI_QUALITY_HIGH
	],
	"gi_half_res": [
		true,
		true,
		false,
		false,
	]
}

func _on_general_quality_option_button_item_selected(index):
	RenderingServer.positional_soft_shadow_filter_set_quality(settings.pos_soft_shadow_filter_quality[index])
	RenderingServer.directional_soft_shadow_filter_set_quality(settings.dir_soft_shadow_filter_quality[index])
	RenderingServer.gi_set_use_half_resolution(settings.gi_half_res[index])
	RenderingServer.directional_shadow_atlas_set_size(settings.directional_shadow_atlas_size[index], true)
	RenderingServer.environment_set_sdfgi_ray_count(settings.ray_count[index])
	RenderingServer.voxel_gi_set_quality(settings.voxel_gi[index])
	get_viewport().positional_shadow_atlas_size = settings.positional_shadow_atlas_size[index]

func _on_close_credits_button_pressed():
	%UI.show()
	%Credits.hide()
	%ResumeButton.grab_focus()


func _on_credits_button_pressed():
	%UI.hide()
	%Credits.show()
	%CloseCreditsButton.grab_focus()


func _on_wishlist_button_pressed(): 
	OS.shell_open("https://store.steampowered.com/app/1513960/FRANZ_FURY/")


func _on_volumentric_fog_checkbox_pressed():
	$WorldEnvironment.environment.volumetric_fog_enabled = %VolumentricFogCheckbox.button_pressed
	$WorldEnvironment.environment.adjustment_saturation = 1.02 if %VolumentricFogCheckbox.button_pressed else 0.95
	$WorldEnvironment.environment.adjustment_contrast = 1.02 if %VolumentricFogCheckbox.button_pressed else 0.95
	GlobalSettings.fog_enabled = %VolumentricFogCheckbox.button_pressed

func _on_v_sync_enable_check_box_pressed():
	var vsync_mode = DisplayServer.VSYNC_DISABLED if not %VSyncEnableCheckBox.button_pressed else DisplayServer.VSYNC_ENABLED
	DisplayServer.window_set_vsync_mode(vsync_mode)
	GlobalSettings.vsync_enabled = %VSyncEnableCheckBox.button_pressed

func _on_ssao_checkbox_pressed():
	$WorldEnvironment.environment.ssao_enabled = %SSAOCheckbox.button_presseds
	GlobalSettings.ssao_enabled = %SSAOCheckbox.button_pressed


func _on_dec_to_bi_stage_pressed() -> void:
	LoaderManager.change_level("res://Numeral_map/num_fl01/beta_numeral_map.tscn")


func _on_logic_stage_pressed() -> void:
	LoaderManager.change_level("res://mastermindgame/master_mind_map.tscn")


func _on_back_button_pressed():
	pass # Replace with function body.
