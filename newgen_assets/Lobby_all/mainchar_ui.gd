extends Control
@export var dec_to_bi_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_button_pressed() -> void:
	$MarginContainer/StartPanel3.show()
	$CharacterButton.hide()
	$ArtifactButton.hide()
	$NextButton.hide()
	$SettingButton.hide()

func _on_back_2_button_pressed() -> void:
	$MarginContainer/StartPanel3.hide()
	$CharacterButton.show()
	$ArtifactButton.show()
	$NextButton.show()
	$SettingButton.show()

	


func _on_dec_to_bi_stage_pressed() -> void:
	#TransitionScreen.transition()
	
	if dec_to_bi_scene:
		var new_scene_instance = dec_to_bi_scene.instantiate()
		#TransitionScreen.transition()
		#TransitionScreen.on_transition_finished
		if new_scene_instance and get_tree():
			# Replace the current scene with the new one
			var current_scene = get_tree().current_scene
			get_tree().root.add_child(new_scene_instance)
			get_tree().current_scene = new_scene_instance
			
			# Free the old scene to avoid memory leaks
			if current_scene:
				current_scene.queue_free()
				TransitionScreen.transition()
				await  TransitionScreen.on_transition_finished
		else:
			print("Error: Could not instantiate the next scene.")
	else:
		print("No next scene set.")
