extends CharacterBody3D

#@onready var camera_mount = $camera_mount
@onready var camera_scene = $CameraScene
@onready var character_graphics = $character_graphics

const SPEED = 5.0
const JUMP_VELOCITY = 10


const run_speed_modifier = 3
var speed_mod : float = 1.0
@export var camera_min : float = -1
@export var camera_max : float = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting('physics/3d/default_gravity')
var was_on_floor : bool

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x)/4)
		camera_scene.gimbal_rotate_x(-deg_to_rad(event.relative.y)/4)
		#camera_mount.rotate_x(-deg_to_rad(event.relative.y)/4)
		#camera_mount.rotation.x = clamp(camera_mount.rotation.x,camera_min,camera_max)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_released('ui_mouse_wheel_up'):
		camera_scene.camera_zoom(-1)
	elif Input.is_action_just_released('ui_mouse_wheel_down'):
		camera_scene.camera_zoom(1)
	if Input.is_action_just_pressed('ui_quit'):
		get_tree().quit()
		
	# Handle Jump.
	if Input.is_action_just_pressed('ui_accept') and is_on_floor():
		velocity.y = JUMP_VELOCITY
		character_graphics.jump()
		
	var sprint_dir = -1
	if Input.is_action_pressed('ui_shift') and is_on_floor():
		sprint_dir = 1
	speed_mod = clamp(speed_mod+(0.2*sprint_dir),1.0,run_speed_modifier)
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	character_graphics.set_move(input_dir)
	character_graphics.set_is_running(sprint_dir == 1)
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED * speed_mod
			velocity.z = direction.z * SPEED * speed_mod
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * speed_mod)
			velocity.z = move_toward(velocity.z, 0, SPEED * speed_mod)
			
#	if is_on_floor():
#		if direction:
#			if abs(input_dir.x) > abs(input_dir.y):
#				var strafe = 'left_strafe'
#				if input_dir.x > 0:
#					strafe = 'right_strafe'
#				strafe = strafe + ('_walk' if sprint_dir==-1 else '_run')
#				character_graphics.play_animation(strafe)
#			else:
#				if input_dir.y > 0:
#					character_graphics.play_animation('walk_back')
#				else:
#					character_graphics.play_animation('walk' if sprint_dir==-1 else 'run')
#			velocity.x = direction.x * SPEED * speed_mod
#			velocity.z = direction.z * SPEED * speed_mod
#		else:
#			character_graphics.play_animation('idle')
#			velocity.x = move_toward(velocity.x, 0, SPEED * speed_mod)
#			velocity.z = move_toward(velocity.z, 0, SPEED * speed_mod)
#	else:
#			character_graphics.play_animation('jump')

	move_and_slide()
