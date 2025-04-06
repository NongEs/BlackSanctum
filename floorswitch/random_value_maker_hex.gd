extends Interactable

@export var label_r: Label3D
@export var label_g: Label3D
@export var label_b: Label3D
@export var difficulty: int = 1  # ระดับความยาก (1-4)
@export var fixed_r: int = 0  # ค่าที่กำหนดเองสำหรับ Level 4
@export var fixed_g: int = 0
@export var fixed_b: int = 0

var random_r: int = 0
var random_g: int = 0
var random_b: int = 0
var has_randomized: bool = false  # ตัวแปรป้องกันการสุ่มหลายรอบ

const BASIC_COLORS = [[255, 0, 0], [0, 255, 0], [0, 0, 255]]  # สีพื้นฐาน RGB
const RAINBOW_COLORS = [
	[255, 0, 0], [255, 127, 0], [255, 255, 0], 
	[0, 255, 0], [0, 0, 255], [75, 0, 130], [148, 0, 211]
]  # สีรุ้ง

signal value_generated(r, g, b)  # สัญญาณส่งค่าไปยัง color_gen_hex

func _on_interacted(_body: Variant) -> void:
	if has_randomized:
		return  # หยุดทันทีถ้าเคยสุ่มไปแล้ว
	has_randomized = true  # ตั้งค่าสถานะว่าเคยสุ่มแล้ว

	_run_random_animation()

func _run_random_animation():
	var steps = 15
	var step_time = 0.05

	for i in range(steps):
		_randomize_color(false)
		_update_labels()
		await get_tree().create_timer(step_time).timeout

	_randomize_color(true)
	_update_labels()

	# ✅ เปลี่ยนจาก color_generated.emit เป็น value_generated.emit
	value_generated.emit(random_r, random_g, random_b)
	print("✅ Emitted signal: value_generated(", random_r, ",", random_g, ",", random_b, ")")

func _randomize_color(final_value = false):
	if final_value and difficulty == 4:
		# Level 4: ใช้ค่าที่ตั้งไว้ล่วงหน้า
		random_r = clamp(fixed_r, 0, 255)
		random_g = clamp(fixed_g, 0, 255)
		random_b = clamp(fixed_b, 0, 255)
	else:
		match difficulty:
			1:
				# Level 1: ใช้สีจาก BASIC_COLORS เท่านั้น
				var color = BASIC_COLORS.pick_random()
				random_r = color[0]
				random_g = color[1]
				random_b = color[2]
			2:
				# Level 2: ใช้สีจาก RAINBOW_COLORS
				var color = RAINBOW_COLORS.pick_random()
				random_r = color[0]
				random_g = color[1]
				random_b = color[2]
			3:
				# Level 3: สุ่มค่าแบบอิสระ
				random_r = randi_range(0, 255)
				random_g = randi_range(0, 255)
				random_b = randi_range(0, 255)
			4:
				# Level 4: จะกำหนดค่าในรอบสุดท้ายเท่านั้น
				random_r = randi_range(0, 255)
				random_g = randi_range(0, 255)
				random_b = randi_range(0, 255)

func _update_labels():
	if label_r: label_r.text = str(random_r)
	if label_g: label_g.text = str(random_g)
	if label_b: label_b.text = str(random_b)
