extends Node3D

var playback: AnimationNodeStateMachinePlayback
var is_open := false

@export var audio_player: NodePath  # Path ไปยัง AudioStreamPlayer
@export var door_sound: AudioStream  # ไฟล์เสียงประตู (Switch_EkOHv_02.wav)

func _ready():
	$AnimationTree.active = true  # เปิดใช้งาน AnimationTree
	playback = $AnimationTree.get("parameters/playback")

	if playback:
		print("✅ Playback successfully initialized!")
	else:
		print("❌ Error: Could not retrieve 'playback' parameter from AnimationTree!")

func toggle():
	if playback == null:
		print("❌ Error: playback is null, cannot toggle door state!")
		return  # ออกจากฟังก์ชันทันที

	is_open = !is_open  # สลับสถานะของประตู
	
	# 🔥 เล่นเสียงก่อนเริ่มแอนิเมชัน
	play_sound()

	if is_open:
		print("🚪 Opening Door...")
		playback.travel("DoorOpen")
	else:
		print("🚪 Closing Door...")
		playback.travel("DoorClose")

# 🔊 ฟังก์ชันเล่นเสียง
func play_sound() -> void:
	if has_node(audio_player):
		var audio_node = get_node(audio_player)
		if door_sound != null:
			audio_node.stream = door_sound
			audio_node.stop()  # หยุดเสียงก่อนหน้า (ถ้ามี)
			audio_node.play()  # เล่นเสียงใหม่
