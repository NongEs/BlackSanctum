extends Interactable

@export var is_on: bool = false
@export var state = 0
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@export var label_3d: NodePath
var material_instance: Material  # Holds the duplicated material instance

signal state_changed(new_state: int)  # Signal to notify state changes

func _ready() -> void:
	set_color(Color.RED)
	var original_material = mesh_instance.get_surface_override_material(0)
	if original_material:
		material_instance = original_material.duplicate()
		mesh_instance.set_surface_override_material(0, material_instance)

func _on_interacted(body: Variant) -> void:
	toggle_switch()

func toggle_switch():
	is_on = not is_on
	state = 1 - state
	#print("Switch", "On" if is_on else "Off", ", State:", state)
	set_color(Color.GREEN if is_on else Color.RED)
	update_label()
	emit_signal("state_changed", state)  # Notify listeners of the state change

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
