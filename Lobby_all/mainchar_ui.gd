extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_button_pressed() -> void:
	$MarginContainer/SelectModePanel.show()
	$CharacterButton.hide()
	$SubChaButton.hide()
	$NextButton.hide()
	$SettingButton.hide()


func _on_practicemodebutton_pressed() -> void:
	$MarginContainer/StartPanel3.show()
	$MarginContainer/SelectModePanel.hide()


func _on_back_2_button_pressed() -> void:
	$MarginContainer/StartPanel3.hide()
	$MarginContainer/SelectModePanel.show()


func _on_back_1_button_pressed() -> void:
	$MarginContainer/SelectModePanel.hide()
	$CharacterButton.show()
	$SubChaButton.show()
	$NextButton.show()
	$SettingButton.show()
