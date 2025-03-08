extends Control

@onready var key_label = %KeyCurrent # อ้างอิงไปที่ Label

func _ready():
	# เชื่อมต่อ Signal เมื่อสถานะเปลี่ยน
	GameState.connect("state_changed", _on_state_changed)
	# อัปเดตค่าเริ่มต้น
	_update_key_label()

func _on_state_changed(key, value):
	if key == "key":
		_update_key_label()

func _update_key_label():
	key_label.text =  str(GameState.get_value("key"))
#"Keys: " +
