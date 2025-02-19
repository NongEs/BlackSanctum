extends Area3D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
# Called when the node enters the scene tree for the first time.

func action() -> void:
	DialogueManager.show_example_dialogue_balloon(dialogue_resource,dialogue_start)
