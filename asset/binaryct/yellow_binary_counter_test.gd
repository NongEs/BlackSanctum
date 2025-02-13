extends Interactable

@export var randomed_number_button: NodePath  # The path to the random number switch button
@export var switches: Array[NodePath] = []  # Array to hold all 8 switch nodes
@export var label_3d: Label3D  # Label3D to display the decimal value, exposed for assignment in the editor
@export var door: Node3D
var current_decimal_value: int = 0  # The current decimal value of the switches
var randomed_number: int = 0  # Holds the value of the random number from the button

func _ready() -> void:
	# Check if Label3D is initialized correctly
	if label_3d == null:
		print("Error: Label3D node not found!")
		return  # Early exit if Label3D is not available

	# Connect the `state_changed` signal for each switch
	for switch_path in switches:
		if has_node(switch_path):
			var switch_node = get_node(switch_path)
			switch_node.connect("state_changed", self._on_switch_state_changed)
	
	# Connect to the random number button if provided
	if has_node(randomed_number_button):
		var random_button = get_node(randomed_number_button)
		random_button.connect("random_number_generated", self._on_random_number_generated)

	# Update the label and check initial state
	update_decimal_value()

func _on_switch_state_changed(new_state: int) -> void:
	update_decimal_value()

func _on_random_number_generated(random_number: int) -> void:
	randomed_number = random_number  # Update the random number
	print("Randomed number received:", randomed_number)
	check_match()  # Check for a match after updating

func update_decimal_value() -> void:
	# Read the states of all switches
	var binary_string: String = ""
	for switch_path in switches:
		if has_node(switch_path):
			var switch_node = get_node(switch_path)
			binary_string += str(switch_node.get_state())  # Append the switch state (0 or 1) as a string

	# Convert the binary string to decimal manually
	current_decimal_value = 0
	var length = binary_string.length()

	for i in range(length):
		if binary_string[i] == "1":
			current_decimal_value += pow(2, length - i - 1)

	# Ensure that we have a valid Label3D before updating it
	if label_3d != null:
		label_3d.text = str(current_decimal_value)
	else:
		print("Error: Label3D is not available to update the text.")
	
	# Check if the decimal value matches the randomed_number
	

func check_match() -> void:
	if current_decimal_value == randomed_number:
		door.toggle()
		print("Match found! Decimal value:", current_decimal_value)
		
