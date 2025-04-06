extends Control

@onready var dialog: RichTextLabel = $RichTextLabel


func _ready():
	dialog.text = "Great job! Let's go to a real race now. You have 2 minutes to get the fastest time as possible"
	await get_tree().create_timer(0.5).timeout
	dialog.text = "MyyaHeeHooHoo"
	await get_tree().create_timer(0.5).timeout  # หน่วงเวลาให้ UI ปรากฏก่อน
	await wait_for_input()
	hide()
	get_tree().paused = false  # เริ่มเกมหลังจากผู้เล่นกดปุ่ม

func wait_for_input():
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("ui_accept"):
			break
