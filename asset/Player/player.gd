extends CharacterBody3D
class_name Player


@export_subgroup("Movement")
@export var speed = 8.0
@export var accel = 16.0
@export var jump = 8.0

@export_subgroup("Crouching")
@export var crouch_speed = 4.0
@export var crouch_height = 2.4
@export var crouch_transition = 8.0

@export_subgroup("Camera")
@export var sensitivity = 0.2
@export var min_angle = -80
@export var max_angle = 90

@export_subgroup("Health")
@export var fall_damage_threshold = 20
@export var fall_damage_multiplier = 1

@onready var head = $Head
@onready var collision_shape = $CollisionShape3D
@onready var top_cast = $TopCast
@onready var ui = $UI

@export_subgroup("headbob")
@export var headbob_frequency := 2.0
@export var headbob_amplitude := 0.04
var headbob_time := 0.0

@export_subgroup("camerashaker")
@export var camera: Camera3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_rot : Vector2
var stand_height : float
var old_vel : float = 0.0
var hurt_tween : Tween
var moving : bool = true
var game_paused := false
@export var movement_enabled: bool = true
func _ready():
	#Dialogic.timeline_started.connect(disable_movement)
	#Dialogic.timeline_ended.connect(enable_movement)
	look_rot.y = rotation_degrees.y
	stand_height = collision_shape.shape.height
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	process_mode = Node.PROCESS_MODE_ALWAYS
#func disable_movement():
#	movement_enabled = false

#func enable_movement():
#	movement_enabled = true
func _physics_process(delta):
	# movement
	var move_speed = speed
	if not movement_enabled:
		velocity = Vector3.ZERO  # Stop movement
		move_and_slide() 
		return  # Skip movement logic when disabled
	if not is_on_floor():
		velocity.y -= gravity * delta * 5.0
	elif moving:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump
		elif Input.is_action_pressed("crouch") or top_cast.is_colliding():
			move_speed = crouch_speed
			crouch(delta)
		else:
			crouch(delta, true)

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and moving:
		velocity.x = lerp(velocity.x, direction.x * move_speed, accel * delta)
		velocity.z = lerp(velocity.z, direction.z * move_speed, accel * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, accel * delta)
		velocity.z = lerp(velocity.z, 0.0, accel * delta)

	move_and_slide()
	
	# rotation
	var plat_rot = get_platform_angular_velocity()
	look_rot.y += rad_to_deg(plat_rot.y * delta)
	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	
	# fall damage
	if old_vel < 0:
		var diff = velocity.y - old_vel
		if diff > fall_damage_threshold:
			#hurt((diff - fall_damage_threshold) * fall_damage_multiplier)
			crouch(delta)
	old_vel = velocity.y
	
	headbob_time += delta * velocity.length()* float(is_on_floor())
	%Camera3D.transform.origin = headbob(headbob_time)
	
func headbob(headbob_time):
	var headbob_position = Vector3.ZERO
	headbob_position.y = sin(headbob_time * headbob_frequency) * headbob_amplitude
	headbob_position.x = cos(headbob_time * headbob_frequency / 2) * headbob_amplitude
	return headbob_position

func shake_camera(duration: float = 5.0, intensity: float = 0.2, fade_duration: float = 1.0):
	if not camera:
		print("Error: Camera not assigned!")
		return
	
	var timer = get_tree().create_timer(duration)
	timer.timeout.connect(func(): camera.transform.origin = Vector3.ZERO)  # Reset after full shake

	# Main shake (full intensity for `duration` seconds)
	while timer.time_left > 0:
		camera.transform.origin = Vector3(randf_range(-intensity, intensity), randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		await get_tree().process_frame
	
	# Smooth fade-out shake (lowering intensity for `fade_duration` seconds)
	timer = get_tree().create_timer(fade_duration)
	while timer.time_left > 0:
		var reduced_intensity = intensity * (timer.time_left / fade_duration)  # Gradually decrease intensity
		camera.transform.origin = Vector3(randf_range(-reduced_intensity, reduced_intensity), randf_range(-reduced_intensity, reduced_intensity), randf_range(-reduced_intensity, reduced_intensity))
		await get_tree().process_frame
	
	# Ensure final reset
	camera.transform.origin = Vector3.ZERO
func _input(event):
	if event is InputEventMouseMotion and moving:
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		game_paused = !game_paused
		get_tree().paused = game_paused
		
		if game_paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # แสดงเมาส์
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # จับเมาส์
func crouch(delta : float, reverse = false):
	var target_height : float = crouch_height if not reverse else stand_height
	
	collision_shape.shape.height = lerp(collision_shape.shape.height, target_height, crouch_transition * delta)
	collision_shape.position.y = lerp(collision_shape.position.y, target_height * 0.5, crouch_transition * delta)
	head.position.y = lerp(head.position.y, target_height - 1, crouch_transition * delta)


#func hurt(damage : float):
	#ui.hurt(damage)
	
	#if ui.health_bar.value <= 0:
	#	die()


#func die():
	##moving = false
	#ui.show_gameover()
