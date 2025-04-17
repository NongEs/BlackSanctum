extends StaticBody3D

@export var delete_button: NodePath
@export var answer_areas: Array[Area3D]
@export var answer_labels: Array[Label3D]

var answer_objects: Array[RigidBody3D] = [null, null, null, null]
var current_values: Array[int] = [-1, -1, -1, -1]
@export var timer: Timer
var all_questions = [
	[0, 0], [0, 1], [1, 0], [1, 1],   # AND
	[0, 0], [0, 1], [1, 0], [1, 1],   # OR
	[0, 0], [0, 1], [1, 0], [1, 1],   # XOR
	[0, 0], [0, 1], [1, 0], [1, 1],   # NAND
	[0, 0], [0, 1], [1, 0], [1, 1],   # NOR
	[0, 0], [0, 1], [1, 0], [1, 1],   # XNOR
	#[0], [1],   # NOT
]

@export var running_timer_label: Label3D
@export var countdown_timer_label: Label3D
@export var start_button: NodePath

var total_questions := 24
var question_index := 0
var used_question_indices := []
var running_time := 0.0
var countdown_time := 30.0  
var game_started := false

@export var question_label: Label3D  # อันเดิม
@export var question_label_2: Label3D
@export var question_label_3: Label3D
@export var question_label_4: Label3D

@export var correct_answer_labels: Array[Label3D] # แสดงคำตอบที่ถูกในแต่ละช่อง
@export var break_status_label: Label3D           # แสดง "Break Time"

var is_break_time := false
var is_ready_countdown := false
var break_time := 10.0
var ready_countdown_time := 5.0

var cleared_in_this_break := false

@export var result_labels: Array[Label3D] = []

@export var score_label: Label3D  # เอาไว้แสดงคะแนน

func _ready():
	GameState.logic_gate_score = 0
	update_score_label()
	
	for i in answer_areas.size():
		answer_areas[i].body_entered.connect(_on_body_entered.bind(i))
	
	# Connect delete button
	if delete_button and has_node(delete_button):
		var btn = get_node(delete_button)
		btn.connect("interacted", _on_delete_pressed)

	if start_button and has_node(start_button):
		var sb = get_node(start_button)
		sb.connect("interacted", _on_start_pressed)

	if timer:
		timer.timeout.connect(_on_countdown_timeout)

func _process(delta):
	if game_started:
		if not is_break_time and not is_ready_countdown:
			countdown_time = max(countdown_time - delta, 0.0)
			running_time += delta
			if countdown_time == 0.0:
				_on_countdown_timeout()

			if break_status_label:
				break_status_label.text = "Question Running"

		elif is_break_time:
			# ❌ ลบการ clear objects ออกจากตรงนี้
			if break_status_label:
				break_status_label.text = "Break Time"

			break_time -= delta
			if break_time <= 0.0:
				is_break_time = false
				is_ready_countdown = true
				ready_countdown_time = 5.0
				cleared_in_this_break = false  # Reset flag here

		elif is_ready_countdown:
			# ✅ ย้าย clear มาไว้ที่นี่
			if not cleared_in_this_break:
				_clear_answer_objects()
				cleared_in_this_break = true

			ready_countdown_time -= delta
			var seconds_left := int(ceil(ready_countdown_time))
			if break_status_label:
				break_status_label.text = str(seconds_left) if seconds_left > 1 else "Ready!"

			if ready_countdown_time <= 0.0:
				break_status_label.text = "Question Running"
				is_ready_countdown = false
				countdown_time = 30.0
				_generate_new_question()

		# Update UI
		if running_timer_label:
			running_timer_label.text = "Time: %.1f" % running_time
		if countdown_timer_label:
			countdown_timer_label.text = "Left: %.1f" % countdown_time

func update_score_label():
	if score_label:
		score_label.text = "Score: %d" % GameState.logic_gate_score
		
func _on_body_entered(body: Node3D, index: int):
	if not body is RigidBody3D or not body.has_method("get_value"):
		return

	var bodies = answer_areas[index].get_overlapping_bodies()
	var valid_objects := []
	for b in bodies:
		if b is RigidBody3D and b.has_method("get_value"):
			valid_objects.append(b)

	if valid_objects.size() == 0:
		return

	var obj = valid_objects[0]
	var val = obj.value
	answer_objects[index] = obj
	current_values[index] = val
	answer_labels[index].text = str(val)
	answer_labels[index].modulate = Color.WHITE

func _on_start_pressed(_unused = null):
	game_started = true
	running_time = 0.0
	countdown_time = 30.0
	used_question_indices.clear()
	_generate_new_question()
	#timer.start(30.0)

func _on_countdown_timeout():
	_check_answer()
	_show_correct_answers()
	is_break_time = true
	break_time = 10.0

func _clear_answer_objects():
	for i in range(answer_areas.size()):
		var bodies = answer_areas[i].get_overlapping_bodies()
		for b in bodies:
			if b is RigidBody3D:
				b.queue_free()
		answer_objects[i] = null
		current_values[i] = -1
		answer_labels[i].text = "null"
		answer_labels[i].modulate = Color.WHITE
		result_labels[i].text = "?"
		result_labels[i].modulate = Color.WHITE
		correct_answer_labels[i].text = "answer"
		correct_answer_labels[i].modulate = Color.WHITE


func _show_correct_answers():
	for i in range(4):
		var q_index: int = used_question_indices[used_question_indices.size() - 4 + i]
		var q = all_questions[q_index]
		var gate_type := int(q_index / 4)
		var correct := 0

		match gate_type:
			0: correct = q[0] & q[1]      # AND
			1: correct = q[0] | q[1]      # OR
			2: correct = q[0] ^ q[1]      # XOR
			3: correct = int(not (q[0] & q[1]))  # NAND
			4: correct = int(not (q[0] | q[1]))  # NOR
			5: correct = int(not (q[0] ^ q[1]))  # XNOR
			6: correct = not q[0]           # NOT (single value)

		correct_answer_labels[i].text = "Ans: %d" % correct
		correct_answer_labels[i].modulate = Color.SKY_BLUE

func _generate_new_question():
	if used_question_indices.size() + 4 > total_questions:
		print("Game Over: All 24 questions used")
		game_started = false
		break_status_label.text = "Game Over"
		await get_tree().create_timer(3.0).timeout
		break_status_label.text = "Go to Lobby" 
		await get_tree().create_timer(2.0).timeout
		LoaderManager.change_level("res://newgen_assets/Lobby_all/main_character_menu.tscn")
		return

	var chosen_indices: Array[int] = []
	while chosen_indices.size() < 4:
		var index := int(randi() % all_questions.size())
		if not used_question_indices.has(index):
			chosen_indices.append(index)
			used_question_indices.append(index)

	var question_labels := [question_label, question_label_2, question_label_3, question_label_4]

	for i in range(4):
		var q = all_questions[chosen_indices[i]] as Array[int]
		var gate_type := int(chosen_indices[i] / 4)
		var gate_name := get_gate_name(gate_type)
		var label: Label3D = question_labels[i]
		label.text = "%d %s %d = ?" % [q[0], gate_name, q[1]]
	
	for lbl in correct_answer_labels:
		lbl.text = ""

func get_gate_name(index: int) -> String:
	match index:
		0: return "AND"
		1: return "OR"
		2: return "XOR"
		3: return "NAND"
		4: return "NOR"
		5: return "XNOR"
		#6: return "NOT"
		_: return "???"

func _check_answer():
	print("Checking answer...")

	var answer_labels_array: Array[Label3D] = answer_labels
	var score_this_round = 0
	for i in range(4):
		var q_index: int = used_question_indices[used_question_indices.size() - 4 + i]
		var q = all_questions[q_index] as Array[int]
		var gate_type := int(q_index / 4)
		var correct := 0

		match gate_type:
			0: correct = q[0] & q[1]      # AND
			1: correct = q[0] | q[1]      # OR
			2: correct = q[0] ^ q[1]      # XOR
			3: correct = int(not (q[0] & q[1]))  # NAND
			4: correct = int(not (q[0] | q[1]))  # NOR
			5: correct = int(not (q[0] ^ q[1]))  # XNOR
			#6: correct = not q[0]           # NOT (single value)
			_: correct = -1

		var val := current_values[i]
		var label: Label3D = result_labels[i]

		if val == correct:
			label.text = "Correct"
			label.modulate = Color.GREEN
			score_this_round += 10
			print("Correct answer for question %d. Score this round: %d" % [i, score_this_round])
			
		else:
			label.text = "Wrong"
			label.modulate = Color.RED
			print("Incorrect answer for question %d. Score this round: %d" % [i, score_this_round])
			
	GameState.logic_gate_score += score_this_round
	print("Total score after this round: %d" % GameState.logic_gate_score)
	update_score_label()
	


func _on_delete_pressed(_unused = null) -> void:
	_clear_answer_objects()
