extends Node3D

# Declare the class globally
class_name LogicGate

@export var input_a: NodePath
@export var input_b: NodePath
@export var gate_type: String = "AND"
@export var label_3d: Label3D
@export var output_from_gate: NodePath

var output: int = 0
var input_a_state: int = 0
var input_b_state: int = 0

# Declare the signal
signal output_changed(new_output_state: int)

func _ready() -> void:
	# Connect input switches to the gate
	if has_node(input_a):
		var switch_a = get_node(input_a)
		if switch_a:
			switch_a.connect("state_changed", Callable(self, "_on_switch_a_state_changed"))
	
	if has_node(input_b):
		var switch_b = get_node(input_b)
		if switch_b:
			switch_b.connect("state_changed", Callable(self, "_on_switch_b_state_changed"))

	# Emit initial output if needed
	update_output()

	# Pass the output to the next gate if connected
	if output_from_gate != null and has_node(output_from_gate):
		var output_gate = get_node(output_from_gate)
		if output_gate and output_gate is LogicGate:
			output_gate.set_inputs(output, output_gate.input_b_state)

# Functions to update states of inputs when switches change
func _on_switch_a_state_changed(new_state: int) -> void:
	input_a_state = new_state
	update_output()

func _on_switch_b_state_changed(new_state: int) -> void:
	input_b_state = new_state
	update_output()

# Main logic to update the output based on the gate type
func update_output() -> void:
	match gate_type:
		"AND":
			output = input_a_state & input_b_state
		"OR":
			output = input_a_state | input_b_state
		"NOT":
			output = 1 - input_a_state
		"NAND":
			output = 1 - (input_a_state & input_b_state)
		"NOR":
			output = 1 - (input_a_state | input_b_state)
		"XOR":
			output = input_a_state ^ input_b_state
		"XNOR":
			output = 1 - (input_a_state ^ input_b_state)

	print("Gate Type:", gate_type, "| Output:", output, "| Input A:", input_a_state, "| Input B:", input_b_state)
	
	# Emit output state change signal
	emit_signal("output_changed", output)

	# Pass the output to the next gate if connected
	if output_from_gate != null and has_node(output_from_gate):
		var output_gate = get_node(output_from_gate)
		if output_gate and output_gate is LogicGate:
			output_gate.set_inputs(output, output_gate.input_b_state)

	update_label()
# Update the visual label to reflect the current output
func update_label() -> void:
	if label_3d:
		label_3d.text = str(output)

# Set the inputs for the connected gate
func set_inputs(a_state: int, b_state: int) -> void:
	# Update both inputs with the new states when connecting gates
	input_a_state = a_state
	input_b_state = b_state
	update_output()

# Return the current output state
func get_output_state() -> int:
	return output
