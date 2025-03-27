extends Node3D

@export var player: CharacterBody3D
@onready var animation_player: AnimationPlayer = $PrototypeMap_1/ButtonFloorOne/AnimationPlayer


func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	GameState.state_changed.connect(_on_key_update)
	#Dialogic.start("timeline")
	
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
