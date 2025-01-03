extends Node3D

@export var input_a: int = 0  # First input (0 or 1)
@export var input_b: int = 0  # Second input (0 or 1)
@export var output: int = 0   # Gate output
@export var gate_type: String = "AND"  # Default gate type
@export var label_3d: Label3D 
@onready var output_label: Label3D = $"../MeshInstance3D/Node3D2/Label3D"  # Reference to a Label3D for displaying the output
@onready var mesh_instance = $MeshInstance3D



func _ready():
	print(gate_type)
	
	# Set the initial color to red
	update_output()

func set_inputs(a: int, b: int):
	input_a = a
	input_b = b
	update_output()

func update_output():
	# Calculate the output based on the gate type
	match gate_type:
		"AND":
			output = input_a & input_b
		"OR":
			output = input_a | input_b
		"NOT":
			output = 1 - input_a  # NOT gate uses only input_a
		"NAND":
			output = 1 - (input_a & input_b)
		"NOR":
			output = 1 - (input_a | input_b)
		"XOR":
			output = input_a ^ input_b
		"XNOR":
			output = 1 - (input_a ^ input_b)
	
	# Update color based on output state
	if output == 1:
		print("Gate State: 1")
		print("input A = ",input_a," and Input B = ",input_b)
		#set_color(Color.GREEN)  # Set color to green when output is 1
	else:
		print("Gate State: 0")
		print("input A = ",input_a," and Input B = ",input_b)
		#set_color(Color.RED)  # Set color to red when output is 0
	
	# Update the label text
	update_label()

func update_label():
	if label_3d:
		label_3d.text = str(output)  # Update the Label3D to show the output
	else:
		print("Error: Output label not found.")
