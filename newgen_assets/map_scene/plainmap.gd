extends Node3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@export var player: CharacterBody3D

func _ready() -> void:
	#audio_stream_player_3d.play()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#Dialogic.start("numeral_system_dialog","beginning")
	Dialogic.start("new_numeral_system_diallog","beginbinarylevel")
	#await Dialogic.timeline_ended
	#player.can_move = true
	player.set_control_enabled(true)
	# รอเพิ่มอีก 5 วินาที
	#await get_tree().create_timer(5.0).timeout

	# เปลี่ยนฉาก
	#LoaderManager.change_level("res://newgen_assets/Lobby_all/main_character_menu.tscn")
	
func _on_key_update(key, value):
	if key == "key" and value == 2:
		print("Key equal to 2")
		
		player.shake_camera(3.0, 0.2, 1.3)


func _on_free_switch_interacted(body: Variant) -> void:
	player.shake_camera(3.0, 0.2, 1.3)
	
