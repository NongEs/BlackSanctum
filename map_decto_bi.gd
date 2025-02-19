extends Node3D

var dialogue_shown := false  # Flag to track if dialogue has been shown

func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	if body is CharacterBody3D and not dialogue_shown:
		dialogue_shown = true  # Set flag to prevent re-triggering
		print("You are in the area!")
		#for action in InputMap.get_actions():
		#	InputMap.action_set_deadzone(action, 5.0)
		DialogueManager.show_example_dialogue_balloon(load("res://firstdialogue.dialogue"), "floatplatform")
		#for action in InputMap.get_actions():
		#	InputMap.action_set_deadzone(action, 0.0)
