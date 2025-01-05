extends Interactable

@export var label_3d: Label3D
var randomed_number: int = 0
var button_pressed: bool = false

var animation_timer: Timer
var animation_speed: float = 0.05  # Initial speed of the animation
var animation_steps: int = 20     # Total number of animation steps
signal random_number_generated(random_number: int)

func emit_random_number():
	emit_signal("random_number_generated", randomed_number)

func _ready() -> void:
	# Initialize the animation timer
	animation_timer = Timer.new()
	animation_timer.one_shot = true
	add_child(animation_timer)
	animation_timer.connect("timeout", self._animate_random_number)

func _on_interacted(body: Variant) -> void:
	if not button_pressed:
		button_pressed = true
		_start_animation()

func _start_animation() -> void:
	animation_steps = 20
	animation_speed = 0.05
	_animate_random_number()

func _animate_random_number() -> void:
	if animation_steps > 0:
		randomed_number = randi() % 254 + 1  # Generate a random number between 1-254
		if label_3d:
			label_3d.text = str(randomed_number)
		print("Current random number: ", randomed_number)  # Log the random number
		animation_steps -= 1
		animation_speed += 0.01  # Slow down the animation
		animation_timer.start(animation_speed)
	else:
		# Final step: keep the last random number
		if label_3d:
			label_3d.text = str(randomed_number)
		print("Final random number: ", randomed_number)  # Log the final random number
		emit_random_number()  # Emit the random number when the animation finishes
