extends StaticBody3D

@export var switches: Array[Node3D]  # 6 switches (3 pairs)
@export var label_r: Label3D
@export var label_g: Label3D
@export var label_b: Label3D
@export var label_switch_1: Label3D
@export var label_switch_2: Label3D
@export var label_switch_3: Label3D
@export var label_switch_4: Label3D
@export var label_switch_5: Label3D
@export var label_switch_6: Label3D
@export var mesh: MeshInstance3D  
@export var check_button: NodePath  
@export var random_value_node: NodePath  # โหนดที่สุ่มค่า
@export var door: Node3D
var r_hex = [0, 0]  
var g_hex = [0, 0]  
var b_hex = [0, 0]  

const HEX_VALUES = "0123456789ABCDEF"  
var can_check = false  # ต้องสุ่มค่าก่อนถึงจะเช็คได้
var has_checked = false # เพิ่มตัวแปรเพื่อตรวจสอบว่าตอบถูกไปแล้วหรือยัง
@onready var tween := get_tree().create_tween()
var r_target = 0  # ค่าเป้าหมายที่สุ่มมา
var g_target = 0
var b_target = 0

func _ready():
	if switches.size() < 6:
		print("❌ Error: Not enough switches! (Need 6 switches)")
		return

	for switch in switches:
		switch.connect("state_changed", _on_switch_toggled.bind(switch))

	# ตรวจสอบโหนดปุ่มเช็ค
	if check_button and has_node(check_button):
		var check_node = get_node(check_button)
		check_node.connect("interacted", _on_check_button_pressed)
		print("✅ Connected check button successfully!")

	# ตรวจสอบโหนดสุ่มค่า
	if random_value_node and has_node(random_value_node):
		var random_node = get_node(random_value_node)
		if random_node.has_signal("value_generated"):
			random_node.connect("value_generated", _on_value_generated)
			print("✅ Connected to Random Value Node!")
		else:
			print("❌ Random value node does not have 'value_generated' signal!")
	else:
		print("❌ Random value node is missing!")

	update_color()

func _on_value_generated(r: int, g: int, b: int):
	""" รับค่าที่สุ่มมาและอัปเดตตัวแปรเป้าหมาย """
	r_target = r
	g_target = g
	b_target = b
	can_check = true  # ตอนนี้สามารถกดเช็คได้

	print("✅ Received Random Values: R =", r_target, " G =", g_target, " B =", b_target)

func _on_switch_toggled(_state: int, switch: Node3D):
	var switch_index = switches.find(switch)

	if switch_index == 0:  
		r_hex[0] = (r_hex[0] + 1) % 16
	elif switch_index == 1:  
		r_hex[1] = (r_hex[1] + 1) % 16
	elif switch_index == 2:  
		g_hex[0] = (g_hex[0] + 1) % 16
	elif switch_index == 3:  
		g_hex[1] = (g_hex[1] + 1) % 16
	elif switch_index == 4:  
		b_hex[0] = (b_hex[0] + 1) % 16
	elif switch_index == 5:  
		b_hex[1] = (b_hex[1] + 1) % 16

	update_color()

func update_color():
	if switches.size() < 6 or not mesh:
		return

	var r_val = r_hex[0] * 16 + r_hex[1]
	var g_val = g_hex[0] * 16 + g_hex[1]
	var b_val = b_hex[0] * 16 + b_hex[1]

	if label_r: label_r.text = str(r_val)
	if label_g: label_g.text = str(g_val)
	if label_b: label_b.text = str(b_val)

	if label_switch_1: label_switch_1.text = HEX_VALUES[r_hex[0]]
	if label_switch_2: label_switch_2.text = HEX_VALUES[r_hex[1]]
	if label_switch_3: label_switch_3.text = HEX_VALUES[g_hex[0]]
	if label_switch_4: label_switch_4.text = HEX_VALUES[g_hex[1]]
	if label_switch_5: label_switch_5.text = HEX_VALUES[b_hex[0]]
	if label_switch_6: label_switch_6.text = HEX_VALUES[b_hex[1]]

	var material = mesh.get_surface_override_material(0)
	if material == null:
		material = StandardMaterial3D.new()
		mesh.set_surface_override_material(0, material)

	material.albedo_color = Color8(r_val, g_val, b_val)

func _on_check_button_pressed(body: Variant):
	""" กดปุ่มเช็คว่าค่าถูกต้องหรือไม่ """
	if not can_check:
		print("❌ You need to generate a value first!")
		return
	
	# ถ้าตรวจสอบไปแล้ว และถูกต้อง ให้หยุดทำงาน
	if has_checked:
		print("⚠️ Already checked! Cannot check again.")
		return

	var r_val = r_hex[0] * 16 + r_hex[1]
	var g_val = g_hex[0] * 16 + g_hex[1]
	var b_val = b_hex[0] * 16 + b_hex[1]

	if r_val == r_target and g_val == g_target and b_val == b_target:
		print("✅ Correct Match!")
		door.toggle()
		has_checked = true  # ป้องกันการเช็คซ้ำ
		apply_glow_effect()  # เรียกใช้ฟังก์ชันเพิ่ม glow effect
	else:
		print("❌ Incorrect. Try again.")

func apply_glow_effect():
	""" เพิ่มเอฟเฟกต์เรืองแสงให้กับวัตถุ """
	if not mesh:
		return
	
	var material = mesh.get_surface_override_material(0)
	if material == null:
		material = StandardMaterial3D.new()
		mesh.set_surface_override_material(0, material)

	material.emission_enabled = true  # เปิดใช้งาน emission
	material.emission = Color8(r_target, g_target, b_target).srgb_to_linear()  # ใช้สีเป้าหมาย
	material.emission_energy = 0.0  # เริ่มที่ความสว่างต่ำ

	# ใช้ tween ทำให้ emission สว่างขึ้นเรื่อย ๆ
	tween.tween_property(material, "emission_energy", 10.0, 0.8)  # ค่อย ๆ เพิ่ม glow ภายใน 0.8 วิ
