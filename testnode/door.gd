extends Node3D

var playback: AnimationNodeStateMachinePlayback
var is_open := false

func _ready():
	$AnimationTree.active = true  # Ensure the AnimationTree is active
	playback = $AnimationTree.get("parameters/playback")
	
	if playback:
		print("Playback successfully initialized!")
	else:
		print("Error: Could not retrieve 'playback' parameter from AnimationTree!")

func toggle():
	is_open = !is_open
	
	if playback:
		if is_open:
			playback.travel("DoorClose")
		else:
			playback.travel("DoorOpen")
	else:
		print("Error: playback is null, cannot toggle door state!")
