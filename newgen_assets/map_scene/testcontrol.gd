extends Control

@onready var key_label = %KeyCurrent # อ้างอิงไปที่ Label
@onready var tuto_key_current = %TutoKeyCurrent

func _ready():
	# เชื่อมต่อ Signal เมื่อสถานะเปลี่ยน
	if not GameState.is_connected("state_changed", _on_state_changed):
		GameState.connect("state_changed", _on_state_changed)

	if not GameState.is_connected("tukey_state_changed", _on_tukey_state_changed):
		GameState.connect("tukey_state_changed", _on_tukey_state_changed)
	_update_key_label()
	_update_tukey_label()
func _exit_tree():
	# ตัดการเชื่อมต่อเมื่อฉากนี้กำลังจะถูกลบออก
	if GameState.is_connected("state_changed", _on_state_changed):
		GameState.disconnect("state_changed", _on_state_changed)

	if GameState.is_connected("tukey_state_changed", _on_tukey_state_changed):
		GameState.disconnect("tukey_state_changed", _on_tukey_state_changed)

func _on_state_changed(key, value):
	if key == "key" and is_instance_valid(key_label):
		_update_key_label()

func _on_tukey_state_changed(tukey, tuvalue):
	if tukey == "tutokey" and is_instance_valid(tuto_key_current):
		_update_tukey_label()
		
		
func _update_key_label():
	key_label.text =  str(GameState.get_value("key"))
#"Keys: " +

func _update_tukey_label():
	if is_instance_valid(tuto_key_current):
		tuto_key_current.text = str(GameState.get_tuvalue("tutokey"))
