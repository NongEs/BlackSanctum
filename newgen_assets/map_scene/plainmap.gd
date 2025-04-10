extends Node3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@export var player: CharacterBody3D

func _ready() -> void:
	#audio_stream_player_3d.play()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Dialogic.start("numeral_system_dialog","beginning")
	
	
func _on_key_update(key, value):
	if key == "key" and value == 2:
		print("Key equal to 2")
		
		player.shake_camera(3.0, 0.2, 1.3)


func _on_free_switch_interacted(body: Variant) -> void:
	player.shake_camera(3.0, 0.2, 1.3)
