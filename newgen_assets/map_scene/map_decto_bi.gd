extends Node3D
#var paused = false
var switchpanel: bool = false
var binarypanel: bool = false
var redpanel: bool = false
@export var player: CharacterBody3D
@export var movement_enabled: bool = true  # Allow movement by default
@onready var anim_player_blockone = $block2/CSGBox3D7/AnimationPlayer
@onready var bridge_player_blockone = $block2/brigde/AnimationPlayer
@onready var left_bridge_player_blocktwo =	$block3/leftsecbox/AnimationPlayer
@onready var bridge_sec_drop = $block3/CSGBox3D3/AnimationPlayer

func _ready() -> void:
	
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("timeline")
	GameState.tukey_state_changed.connect(_on_tukey_update)
	GameState.set_tovalue("tutokey", 0)
	
func _on_tukey_update(tukey, tuvalue):
	#1s
	if tukey == "tutokey" and tuvalue == 1:
		print("TuKey equal to 1")
		#Dialogic.start("new_numeral_system_diallog","firstkeyscollected")
	
	if tukey == "tutokey" and tuvalue == 4:
		print("TuKey equal to 4")
		await get_tree().create_timer(1.0).timeout
		Dialogic.start("storyskibidii","goodjob")
		await get_tree().create_timer(3.0).timeout
		LoaderManager.change_level("res://Numeral_map/num_fl01/beta_numeral_map.tscn")
func _input(event):
	if not movement_enabled:
		return  # Ignore all input if movement is disabled
	if event.is_action_pressed("ui_cancel"):
		Engine.time_scale = 0
		#$pausemenu.show()
			#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Show cursor when paused

	else:
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Hide cursor for gameplay
		#$pausemenu.hide()
		
func _on_dialogic_signal(argument: String):
	if argument == "move left noi":
		print("my ya hee hoo hoo")
		anim_player_blockone.play("move_left")
		player.shake_camera(4.0, 0.2, 4.2)
		bridge_player_blockone.play("bridge_move")
		
	if argument == "move bridge left":
		left_bridge_player_blocktwo.play("move_left_sec_ox")
		player.shake_camera(3.0, 0.2, 2.2)
		
	if argument == "bridgei fall now":
		bridge_sec_drop.play("bridge_fall")
		player.shake_camera(2.0, 0.2, 1.5)
		
func disable_movement(_timeline = null):
	if player:
		player.movement_enabled = false
		print("Dialogue started, movement disabled!")

# ✅ Enable movement when dialogue ends
func enable_movement(_timeline = null):
	if player:
		player.movement_enabled = true
		print("Dialogue ended, movement enabled!")

	
func _on_area_3d_body_entered(body:CharacterBody3D) -> void:
		#Dialogic.start("timeline")
	if not switchpanel:
		switchpanel = true
		Dialogic.start("storyskibidii")
		print("You are in the area!")
		


func _on_binary_area_body_entered(body: CharacterBody3D) -> void:
	if not binarypanel:
		binarypanel = true
		Dialogic.start("storyskibidii","binarycounter")
		print("You are in the area!")


func _on_red_area_body_entered(body: CharacterBody3D) -> void:
	if not redpanel:
		redpanel = true
		Dialogic.start("storyskibidii","gonext")
		print("You are in the area!")
