extends Interactable

@export var is_on: bool = false
@export var state = 0
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@export var label_3d: NodePath
@export var door: Node3D

@export var audio_player: NodePath  # Path ไปยัง AudioStreamPlayer
@export var switch_sound: AudioStream

var material_instance: Material  # Holds the duplicated material instance

signal state_changed(new_state: int)  # Signal to notify state changes

func _ready() -> void:
	# Set color based on the initial state
	update_color_from_state()
	
	var original_material = mesh_instance.get_surface_override_material(0)
	if original_material:
		material_instance = original_material.duplicate()
		mesh_instance.set_surface_override_material(0, material_instance)

func _on_interacted(body: Variant) -> void:
	toggle_switch()
	
	
func toggle_switch():
	is_on = not is_on
	state = 1 - state
	# Set the color when toggling
	#door.toggle()
	update_color_from_state()
	update_label()
	emit_signal("state_changed", state)  # Notify listeners of the state change
	
func update_color_from_state():
	# Set color based on state: Red for 0, Green for 1
	set_color(Color.RED if state == 0 else Color.GREEN)

func set_color(color: Color) -> void:
	if material_instance:
		material_instance.albedo_color = color

func update_label() -> void:
	if has_node(label_3d):
		var label = get_node(label_3d) as Label3D
		if label:
			label.text = str(state)

func get_state() -> int:
	return state

func play_sound() -> void:
	if has_node(audio_player):
		var audio_node = get_node(audio_player)
		if switch_sound != null:
			audio_node.stream = switch_sound
			audio_node.stop()  # หยุดเสียงก่อนหน้า (ถ้ามี)
			audio_node.play()  # เล่นเสียงใหม่
