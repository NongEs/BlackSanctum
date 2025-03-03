extends Node2D

@onready var animation_intro: AnimationPlayer = $AnimationPlayer

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	animation_intro.play("black_in")
	get_tree().create_timer(2.4).timeout.connect(black_out)
	#if black_out():
		
	
func black_out():
	animation_intro.play("black_out")
	$anggycat.play()
	get_tree().create_timer(3).timeout.connect(start_menu_scene)

func start_menu_scene():
	get_tree().change_scene_to_file("res://Lobby_all/main_character_menu.tscn")
