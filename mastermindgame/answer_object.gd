
extends RigidBody3D

@export var value: int = 0  # 0 or 1

func get_value() -> int:
	return value

func _ready():
	add_to_group("draggable")
