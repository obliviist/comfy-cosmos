extends KinematicBody

export var max_speed = 12
export var acceleration = 60
export var friction = 50
export var air_friction = 10
export var jump_impulse = 20
export var gravity = -40

export var mouse_sensitivity = 0.2
export var controller_sensitivity = 3

export (int, 0, 10) var push = 1

var velocity = Vector3.ZERO
var snap_vector = Vector3.ZERO

onready var head = $Head
onready var interaction = $Head/Camera/Interaction
onready var hand = $Head/Camera/Hand
onready var joint = $Head/Camera/Generic6DOFJoint
onready var staticbody = $Head/Camera/StaticBody
onready var camera =$Head/Camera
onready var anim = get_node("player/PlayerAnimationPlayer")

var picked_object
var pull_power = 4
var rotation_power = 0.05
var locked = false

func _ready():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalSettings.connect("fov_updated", self, "_on_fov_updated")
	GlobalSettings.connect("mouse_sens_updated", self, "_on_mouse_sens_updated")
	#global_transform.origin = Vector3(-8.5, 42, 11)

#unused screenshot code below 
#i use this for taking screenshots during playtests
#func _capture_screen():
	#var vpt: Viewport = get_viewport()
	#var tex: Texture = vpt.get_texture()
	#var img: Image = tex.get_data()
	#img.flip_y()
	#img.save_png("res://user/screenshot.png")
	
func _unhandled_input(event):
	if event.is_action_pressed("lclick"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if event.is_action_pressed("toggle_mouse_mode"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		
func pick_object():
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody:
		picked_object = collider
		joint.set_node_b(picked_object.get_path())
		
func remove_object():
	if picked_object != null:
		picked_object = null
		joint.set_node_b(joint.get_path())
		
func _input(event):
	
	if Input.is_action_just_pressed("lclick"):
		if picked_object == null:
			pick_object()
		elif picked_object != null:
			remove_object()
	
	if GlobalSettings.get_disabled_input():
		return
			
	#if Input.is_action_just_pressed("capture_screen"):
		#_capture_screen()
	
func _physics_process(delta):
	var input_vector = get_input_vector()
	var direction = get_direction(input_vector)
	apply_movement(direction, delta)
	apply_friction(direction, delta)
	apply_gravity(delta)
	jump()
	apply_controller_rotation()
	head.rotation.x = clamp(head.rotation.x, deg2rad(-75), deg2rad(75))
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector3.UP, true, 4, .785398, false)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	for idx in get_slide_count():
		var collision = get_slide_collision(idx)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * velocity.length() * push)
	
	if picked_object != null:
		var a = picked_object.global_transform.origin
		var b = hand.global_transform.origin
		picked_object.set_linear_velocity((b-a)*pull_power)
	
	update_interaction()

func _process(delta):
	var target_dir = Vector2(0, 0)
	if Input.is_action_pressed("move_forward") && Input.is_action_pressed("move_left"):
		target_dir.x += 1
		anim.play("player_for_left")
	elif Input.is_action_pressed("move_forward") && Input.is_action_pressed("move_right"):
		target_dir.x += 1
		anim.play("player_for_right")
		
	elif Input.is_action_pressed("move_forward"):
		target_dir.y += 1
		anim.play("player_walk", 0.1)
		
	if Input.is_action_pressed("move_backward") && Input.is_action_pressed("move_left"):
		target_dir.x += 1
		anim.play_backwards("player_for_right")
	elif Input.is_action_pressed("move_backward") && Input.is_action_pressed("move_right"):
		target_dir.x += 1
		anim.play_backwards("player_for_left")
	elif Input.is_action_pressed("move_backward"):
		target_dir.y += 1
		anim.play_backwards("player_walk", 0.1)
		
		
	elif Input.is_action_pressed("move_left"):
		target_dir.x += 1
		anim.play("player_for_left", 0.1)
	elif Input.is_action_pressed("move_right"):
		target_dir.x += 1
		anim.play("player_for_right", 0.1)
	
	if target_dir.length() == 0 and is_on_floor():
		return
	else:
		if $Timer.time_left <= 0 and is_on_floor():
			$FootstepPlayer.pitch_scale = rand_range(0.5, 0.6)
			$FootstepPlayer.play()
			$Timer.start(0.4)
		elif $Timer.time_left <= 0 and !is_on_floor():
			$JumpPlayer.pitch_scale = rand_range(0.6, 0.8)
			$JumpPlayer.play()
			$Timer.start(1.5)

	set_anim(target_dir)

func set_anim(dir):
	if dir == Vector2(0, 0) and anim.current_animation != "player_idle":
		anim.play("player_idle", 0.1)

func get_input_vector():
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	return input_vector.normalized() if input_vector.length() > 1 else input_vector
	
func get_direction(input_vector):
	var direction = Vector3.ZERO
	direction = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	return direction
	
func apply_movement(direction, delta):
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * max_speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * max_speed, acceleration * delta).z
		
func apply_friction(direction, delta):
	if direction == Vector3.ZERO:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			velocity.x = velocity.move_toward(Vector3.ZERO, air_friction * delta).x
			velocity.z = velocity.move_toward(Vector3.ZERO, air_friction * delta).z

# this is the gravity function below

func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, gravity, jump_impulse)
	
	
func update_snap_vector():
	snap_vector = -get_floor_normal() if is_on_floor() else Vector3.DOWN

# this is the jump function below
	
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap_vector = Vector3.ZERO
		velocity.y = jump_impulse
		anim.play("player_jump", -1, 0.1)
	if Input.is_action_just_released("jump") and velocity.y > jump_impulse / 2:
		velocity.y = jump_impulse / 2

# this is the controller rotation function below

func apply_controller_rotation():
	var axis_vector = Vector2.ZERO
	axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	
	if InputEventJoypadMotion:
		rotate_y(deg2rad(-axis_vector.x) * controller_sensitivity)
		head.rotate_x(deg2rad(-axis_vector.y) * controller_sensitivity)

func _on_Death_body_entered(body):
	if body.is_in_group("player"):
		SimpleSave.save_scene(get_tree(), "res://save_slots/save_continue.tscn")
		get_tree().change_scene("res://src/gui/continue_menu.tscn")
		
func _on_fov_updated(value):
	camera.fov = value

func _on_mouse_sens_updated(value):
	mouse_sensitivity = value

func update_interaction():
	if $InteractArea/CollisionShape.disabled == false:
		$InteractArea/CollisionShape.disabled = true
	if Input.is_action_just_pressed("interact"):
		$InteractArea/CollisionShape.disabled = false

func _on_InteractArea_body_entered(body):
	if body.is_in_group("NPC"):
		body.start_dialog()
	elif body.is_in_group("level_gate"):
		body.start_level_request_dialog()

