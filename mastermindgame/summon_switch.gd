extends Interactable

@export var object_scene: PackedScene
@export var spawn_position: Marker3D
@export var spawn_value: int = 0

func _on_interacted(body: Variant) -> void:
	if object_scene and spawn_position:
		var obj = object_scene.instantiate()
		obj.global_position = spawn_position.global_position
		obj.value = spawn_value
		get_tree().current_scene.add_child(obj)
