extends Interactable

@export var randomed_number_button: NodePath  # The path to the random number switch button
@export var switches: Array[NodePath] = []  # Array to hold all 8 switch nodes
@export var label_3d: Label3D  # Label3D to display the decimal value
@export var door: Node3D
@export var check_button: NodePath  # The Check button
@export var audio_player: NodePath  # AudioPlayer for playing sounds
@export var correct_sound: AudioStream  # Sound when the answer is correct
@export var wrong_sound: AudioStream  # Sound when the answer is wrong

var current_decimal_value: int = 0  # The current decimal value of the switches
@export var randomed_number: int = 0  # Holds the value of the random number from the button
var is_checked: bool = false  # To check if the answer has been checked already

func _ready() -> void:
	# Ensure Label3D and other nodes are initialized correctly
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

	# Connect the check button if provided
	if has_node(check_button):
		var check_btn = get_node(check_button)
		check_btn.connect("interacted", self._on_check_button_pressed)

	# Update the label and check initial state
	update_decimal_value()

func _on_switch_state_changed(new_state: int) -> void:
	update_decimal_value()  # Only update the displayed value, do not check for match

func _on_random_number_generated(random_number: int) -> void:
	randomed_number = random_number  # Update the random number
	print("Randomed number received:", randomed_number)

func _on_check_button_pressed(body: Variant) -> void:
	# Ensure the button is not pressed more than once
	if is_checked:
		print("Answer already checked!")
		return

	print("Check button pressed!")
	check_match()  # Now, we check for correctness

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

func check_match() -> void:
	if randomed_number == 0:
		return

	if current_decimal_value == randomed_number:
		if not is_checked:  # Check if the answer hasn't been checked before
			door.toggle()  # Open the door if the answer is correct
			play_sound(correct_sound)  # Play correct sound
			print("✅ Match found! Decimal value:", current_decimal_value)
			is_checked = true  # Lock further checks
	else:
		if not is_checked:  # Check if the answer hasn't been checked before
			play_sound(wrong_sound)  # Play wrong sound
			print("❌ Wrong attempt! Decimal value:", current_decimal_value)

# Helper function to play sound
func play_sound(sound: AudioStream) -> void:
	if has_node(audio_player):
		var audio_node = get_node(audio_player)
		if sound != null:
			audio_node.stream = sound
			audio_node.play()  # Play the sound
