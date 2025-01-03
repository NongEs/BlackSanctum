extends Control

const WORLDTESTER = preload("res://map_scene/worldtester.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	$MarginContainer/SelectModePanel.show()
	$MarginContainer/StartPanel.hide()


func _on_texture_button_3_pressed() -> void:
	get_tree().quit()


func _on_back_1_button_pressed() -> void:
	$MarginContainer/StartPanel.show()
	$MarginContainer/SelectModePanel.hide()


func _on_practicemodebutton_pressed() -> void:
	$MarginContainer/StartPanel3.show()
	$MarginContainer/SelectModePanel.hide()
	


func _on_back_2_button_pressed() -> void:
	$MarginContainer/SelectModePanel.show()
	$MarginContainer/StartPanel3.hide()


func _on_dec_to_bi_stage_pressed() -> void:
	get_tree().change_scene_to_file("res://map_scene/worldtester.tscn")
