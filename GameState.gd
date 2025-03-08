extends Node

var state := {
	"health": 100,
	"key": 0
}
signal state_changed(key, value)  # สร้าง Signal

func has_value(key):
	return state.has(key)


func get_value(key):
	if state.has(key):
		return state[key]
	
	printerr("Key not present in state: ", key)
	return null

func set_value(key, value):
	state[key] = value
	emit_signal("state_changed", key, value)
