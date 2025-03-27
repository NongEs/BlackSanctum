extends Interactable

@export var randomed_number_button: NodePath  # ปุ่มสุ่มตัวเลข
@export var switches: Array[NodePath] = []  # Array เก็บ 8 switches
@export var label_3d: Label3D  # Label3D แสดงค่า decimal
@export var label_octal_1: Label3D  # Octal digit (LSB)
@export var label_octal_2: Label3D  # Octal digit (Middle)
@export var label_octal_3: Label3D  # Octal digit (MSB)
@export var door: Node3D  # ประตู
@export var check_button: NodePath  # ปุ่มกดตรวจสอบ
@export var audio_player: NodePath  # ตัวเล่นเสียง 3D
@export var correct_sound: AudioStream  # เสียงเมื่อคำตอบถูก
@export var wrong_sound: AudioStream  # เสียงเมื่อคำตอบผิด

var current_decimal_value: int = 0  # ค่าปัจจุบัน
@export var randomed_number: int = 0  # ค่าตัวเลขที่สุ่มได้
var is_correct: bool = false  # **ตัวแปรเช็คว่าตอบถูกแล้วหรือยัง**

func _ready() -> void:
	# เชื่อมสัญญาณให้ Switch
	for switch_path in switches:
		if has_node(switch_path):
			var switch_node = get_node(switch_path)
			switch_node.connect("state_changed", self._on_switch_state_changed)

	# เชื่อมปุ่มสุ่มตัวเลข
	if has_node(randomed_number_button):
		var random_button = get_node(randomed_number_button)
		random_button.connect("random_number_generated", self._on_random_number_generated)

	# เชื่อมปุ่มตรวจคำตอบ
	if has_node(check_button):
		var check_btn = get_node(check_button)
		check_btn.connect("interacted", self._on_check_button_pressed)

	# อัปเดตค่าเริ่มต้น
	update_decimal_value()

func _on_switch_state_changed(new_state: int) -> void:
	update_decimal_value()

func _on_random_number_generated(random_number: int) -> void:
	randomed_number = random_number
	is_correct = false  # **รีเซ็ตสถานะเพื่อตรวจใหม่**
	print("Randomed number received:", randomed_number)

func _on_check_button_pressed(body: Variant) -> void:
	print("Check button pressed!")
	check_match()

func update_decimal_value() -> void:
	# แปลงค่า switch เป็นไบนารี
	var binary_string: String = ""
	for switch_path in switches:
		if has_node(switch_path):
			var switch_node = get_node(switch_path)
			binary_string += str(switch_node.get_state())

	# เติม 0 ให้ความยาวเป็นเลข 3 หารลงตัว
	while binary_string.length() % 3 != 0:
		binary_string = "0" + binary_string

	# แปลงเป็น Octal และ Decimal
	var decimal_value = 0
	var power = 0
	var octal_digits: Array[int] = []

	for i in range(binary_string.length(), 0, -3):
		var start_index = max(0, i - 3)
		var octal_digit = binary_string.substr(start_index, i - start_index)
		var octal_value = binary_to_decimal(octal_digit)
		decimal_value += octal_value * pow(8, power)
		octal_digits.append(octal_value)
		power += 1

	# อัปเดตค่าปัจจุบัน
	current_decimal_value = decimal_value

	# อัปเดต Label3D
	if label_3d != null:
		label_3d.text = str(current_decimal_value)

	if octal_digits.size() >= 1 and label_octal_1 != null:
		label_octal_1.text = str(octal_digits[0])
	if octal_digits.size() >= 2 and label_octal_2 != null:
		label_octal_2.text = str(octal_digits[1])
	if octal_digits.size() >= 3 and label_octal_3 != null:
		label_octal_3.text = str(octal_digits[2])

func binary_to_decimal(binary: String) -> int:
	var value = 0
	var length = binary.length()
	for i in range(length):
		if binary[i] == "1":
			value += pow(2, length - i - 1)
	return value

func check_match() -> void:
	if randomed_number == 0:
		return

	if current_decimal_value == randomed_number:
		if not is_correct:  # **เช็คว่าตอบถูกครั้งแรกเท่านั้น**
			print("✅ Match found! Decimal value:", current_decimal_value)
			
			if door != null:
				print("🔓 Toggling door...")
				if door.has_method("toggle"):  # ตรวจสอบว่า door มีฟังก์ชัน toggle หรือไม่
					door.toggle()
				else:
					print("⚠️ Door node does not have a 'toggle()' method!")
			else:
				print("⚠️ Door node is null!")

			play_sound(correct_sound)
			is_correct = true  # **ล็อคไม่ให้เช็คซ้ำ**
	else:
		print("❌ Wrong attempt! Decimal value:", current_decimal_value)
		play_sound(wrong_sound)  # ถ้าผิดยังสามารถตรวจซ้ำได้


func play_sound(sound: AudioStream) -> void:
	if has_node(audio_player):
		var audio_node = get_node(audio_player)
		if sound != null:
			audio_node.stream = sound
			audio_node.play()
