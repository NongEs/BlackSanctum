extends MeshInstance3D


@export var current_gate_scene: PackedScene  # The current gate scene (e.g., AND gate)
var current_gate_instance: Node3D = null  # Reference to the current gate instance

func place_gate(new_gate_scene: PackedScene):
	# Remove the current gate if it exists
	if current_gate_instance:
		current_gate_instance.queue_free()
	
	# Instantiate the new gate
	current_gate_instance = new_gate_scene.instantiate() as Node3D
	add_child(current_gate_instance)
	current_gate_instance.global_transform = Transform3D()  # Reset position
