extends CharacterBody3D
class_name MovementController

@export_subgroup("Movement")
@export var speed := 12.0
@export var jump_height := 10.0


@export_subgroup("Crouching")
@export var crouch_speed = 4.0
@export var crouch_height = 2.4
@export var crouch_transition = 8.0

@onready var head = %Head
@onready var collision_shape = $CollisionShape3D
@onready var top_cast = $TopCast
@onready var ui = $UI

@export_subgroup("headbob")
@export var headbob_camera: Camera3D
@export var headbob_frequency := 2.0
@export var headbob_amplitude := 0.04
var headbob_time := 0.0

@export_subgroup("camerashaker")
@export var camera: Camera3D


@export var gravity_multiplier := 3.0
#@export var speed := 10
@export var acceleration := 8
@export var deceleration := 10
@export_range(0.0, 1.0, 0.05) var air_control := 0.3
#@export var jump_height := 10
var direction := Vector3()
var input_axis := Vector2()
var is_active := false:
	set(val):
		is_active = val
		%Head.is_active = is_active
		set_physics_process(is_active)
	get:
		return is_active

var stand_height : float
var moving : bool = true


@export_subgroup("Dragobject")
@export var interaction : RayCast3D
@export var hand : Marker3D
var picked_object
var pull_power := 6
@export var joint : Generic6DOFJoint3D
@export var staticbody : StaticBody3D
var rotation_power := 0.05
var locked = false
var can_move := true
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)

func _ready():
	
	stand_height = collision_shape.shape.height
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	
	
# Called every physics tick. 'delta' is constants
func _physics_process(delta: float) -> void:
	if can_move:
		@warning_ignore("unused_variable")
		var move_speed = speed
		input_axis = Input.get_vector(&"backward", &"forward",
			&"left", &"right")
		
		direction_input()
		
		if is_on_floor():
			if Input.is_action_just_pressed(&"jump"):
				velocity.y = jump_height
				
		if not is_on_floor_only():
			velocity.y -= gravity * delta
		elif moving:
			if Input.is_action_just_pressed(&"jump"):
				velocity.y = jump_height
			elif Input.is_action_pressed("crouch") or top_cast.is_colliding():
				move_speed = crouch_speed
				crouch(delta)
			else:
				crouch(delta, true)
		
		accelerate(delta)
		move_and_slide()
		
		headbob_time += delta * velocity.length() * float(is_on_floor())
		headbob_camera.transform.origin = headbob(headbob_time)

		if picked_object != null:
			var a = picked_object.global_transform.origin
			var b = hand.global_transform.origin
			picked_object.set_linear_velocity((b - a) * pull_power)

	
#@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse_click"):
		if picked_object == null:
			pick_object()
			
		elif picked_object != null:
			remove_object()
			
	if Input.is_action_just_pressed("throw"):
		if picked_object != null:
			var knockback = picked_object.position - position
			picked_object.apply_central_impulse(knockback * 3)
			remove_object()
	
func set_control_enabled(enabled: bool) -> void:
	can_move = enabled  # สมมติว่าคุณมีตัวแปรนี้ควบคุมการเดิน
	%Head.set_camera_active(enabled)  # ส่งต่อให้กล้องใน Head
	
func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	direction = aim.z * -input_axis.x + aim.x * input_axis.y

func pick_object():
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody3D:
		picked_object = collider
		joint.set_node_b(picked_object.get_path())
	
func remove_object():
	if picked_object != null:
		picked_object = null
		joint.set_node_b(joint.get_path())

func accelerate(delta: float) -> void:
	# Using only the horizontal velocity, interpolate towards the input.
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * speed
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	temp_vel = temp_vel.lerp(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z
	
func crouch(delta : float, reverse = false):
	var target_height : float = crouch_height if not reverse else stand_height
	collision_shape.shape.height = lerp(collision_shape.shape.height, target_height, crouch_transition * delta)
	collision_shape.position.y = lerp(collision_shape.position.y, target_height * 0.5, crouch_transition * delta)
	head.position.y = lerp(head.position.y, target_height - 1, crouch_transition * delta)

func shake_camera(duration: float = 5.0, intensity: float = 0.2, fade_duration: float = 1.0):
	if not camera:
		print("Error: Camera not assigned!")
		return
	var timer = get_tree().create_timer(duration)
	timer.timeout.connect(func(): camera.transform.origin = Vector3.ZERO)  # Reset after full shake

	# Main shake (full intensity for duration seconds)
	while timer.time_left > 0:
		camera.transform.origin = Vector3(randf_range(-intensity, intensity), randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		await get_tree().process_frame
	
	# Smooth fade-out shake (lowering intensity for fade_duration seconds)
	timer = get_tree().create_timer(fade_duration)
	while timer.time_left > 0:
		var reduced_intensity = intensity * (timer.time_left / fade_duration)  # Gradually decrease intensity
		camera.transform.origin = Vector3(randf_range(-reduced_intensity, reduced_intensity), randf_range(-reduced_intensity, reduced_intensity), randf_range(-reduced_intensity, reduced_intensity))
		await get_tree().process_frame
	# Ensure final reset
	camera.transform.origin = Vector3.ZERO

@warning_ignore("shadowed_variable")
func headbob(headbob_time):
	var headbob_position = Vector3.ZERO
	headbob_position.y = sin(headbob_time * headbob_frequency) * headbob_amplitude
	headbob_position.x = cos(headbob_time * headbob_frequency / 2) * headbob_amplitude
	return headbob_position 
