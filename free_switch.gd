extends Interactable

@export var state: int = 0  # เก็บค่าสถานะของสวิตช์ (0 หรือ 1)
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

signal state_changed(new_state: int)  # ส่งสัญญาณเมื่อสถานะเปลี่ยน

func _on_interacted(body: Variant) -> void:
	toggle_switch()

func toggle_switch():
	state = 1 - state  # สลับค่า 0 ⇄ 1
	update_color()
	emit_signal("state_changed", state)  # แจ้งไปยังตัวที่คุมพวกสวิตช์

func update_color():
	var color = Color.RED if state == 0 else Color.GREEN
	if mesh_instance:
		var material = mesh_instance.get_surface_override_material(0)
		if material:
			material.albedo_color = color
