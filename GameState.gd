extends Node

var state := {
	"health": 100,
	"key": 0,
	"tutokey": 0
}

# เพิ่มตัวแปร Global แบบเฉพาะสำหรับแมพนี้
var numeral_system_timer := 0.0
var numeral_system_tier := "Unranked"

# Global score สำหรับ logic gate game
var logic_gate_score := 0

signal state_changed(key, value)
signal tukey_state_changed(tutokey, tuvalue)

func has_value(key):
	return state.has(key)

func has_tuvalue(tutokey):
	return state.has(tutokey)
	
func get_tuvalue(tutokey):
	if state.has(tutokey):
		return state[tutokey]
	printerr("TutoKey not present in state: ", tutokey)
	return null
	
	
func get_value(key):
	if state.has(key):
		return state[key]
	printerr("Key not present in state: ", key)
	return null

func set_tovalue(tutokey, tuvalue):
	state[tutokey] = tuvalue
	emit_signal("tukey_state_changed", tutokey, tuvalue)

func set_value(key, value):
	state[key] = value
	emit_signal("state_changed", key, value)
