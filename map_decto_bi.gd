extends Node3D
#var paused = false
var switchpanel: bool = false
var binarypanel: bool = false
var redpanel: bool = false
func _ready() -> void:
	$pausemenu.hide()
	
	Dialogic.start("timeline")
	
	
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Engine.time_scale = 0
		$pausemenu.show()
			#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Show cursor when paused

	else:
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Hide cursor for gameplay
		$pausemenu.hide()

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
