extends Node

var loading_screen: PackedScene = preload("res://autoload/loading_screen.tscn")
var target_scene: PackedScene

func set_next_scene(scene: PackedScene) -> void:
	target_scene = scene

func load_scene(scene_to_load: PackedScene = target_scene) -> void:
	target_scene = scene_to_load
	var loading_instance = loading_screen.instantiate()
	get_tree().root.add_child(loading_instance)
