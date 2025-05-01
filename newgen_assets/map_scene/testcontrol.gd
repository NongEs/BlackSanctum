extends Control

@onready var key_label = %KeyCurrent # อ้างอิงไปที่ Label
@onready var tuto_key_current: Label = %TutoKeyCurrent

func _ready():
	# เชื่อมต่อ Signal เมื่อสถานะเปลี่ยน
	GameState.connect("state_changed", _on_state_changed)
	# อัปเดตค่าเริ่มต้น
	GameState.connect("tukey_state_changed", _on_tukey_state_changed)
	_update_key_label()
	_update_tukey_label()
func _on_state_changed(key, value):
	if key == "key":
		_update_key_label()


func _on_tukey_state_changed(tukey, tuvalue):
	if tukey == "tutokey":
		_update_tukey_label()
		
		
func _update_key_label():
	key_label.text =  str(GameState.get_value("key"))
#"Keys: " +

func _update_tukey_label():
	tuto_key_current.text =  str(GameState.get_value("tutokey"))
